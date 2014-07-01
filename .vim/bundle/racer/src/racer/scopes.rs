use std::io::File;
use std::io::BufferedReader;

use racer;
use racer::codecleaner;
use racer::codeiter;

pub fn find_closing_paren(src:&str, mut pos:uint) -> uint {
    let openparen: u8 = "("[0] as u8;
    let closeparen: u8 = ")"[0] as u8;

    let mut levels = 0i;
    loop {
        if src[pos] == closeparen { 
            if levels == 0 {
                break;
            } else {
                levels -= 1;
            }
        }
        if src[pos] == openparen {
            levels += 1;
        }
        pos += 1;
    }
    return pos;
}


pub fn scope_start(src:&str, point:uint) -> uint {
    let s = src.slice(0,point);
    let mut pt = point;
    let mut levels = 0i;
    for c in s.chars().rev() {
        if c == '{' { 
            if levels == 0 {
                break;
            } else {
                levels -= 1;
            }
        }
        if c == '}' {
            levels += 1;
        }
        pt -= 1;
    }
    return pt;
}

pub fn find_stmt_start(msrc: &str, point: uint) -> Option<uint> {
    // iterate the scope to find the start of the statement
    let scopestart = scope_start(msrc, point);
    for (start, end) in codeiter::iter_stmts(msrc.slice_from(scopestart)) {
        if (scopestart + end) > point {
            return Some(scopestart+start);
        }
    }
    return None;
}

pub fn split_into_context_and_completion<'a>(s: &'a str) -> (&'a str, &'a str, racer::CompletionType) {

    let mut start = 0;
    let colon: u8 = ":"[0];
    let dot: u8 = "."[0];

    for (i, c) in s.char_indices().rev() {
        if ! racer::is_ident_char(c) {
            start = i+1;
            break;
        }
    }

    if start != 0 && s[start-1] == dot {    // field completion
        return (s.slice_to(start-1), s.slice_from(start), racer::Field);
    }

    if start > 0 && s[start-1] == colon {  // path completion
        return (s.slice_to(start-2), s.slice_from(start), racer::Path);
    }

    return (s.slice_to(start), s.slice_from(start), racer::Path);
}

pub fn get_start_of_search_expr(msrc: &str, point: uint) -> uint {
    let openparen: u8 = "("[0];
    let closeparen: u8 = ")"[0];
    let mut levels = 0i;
    let mut i = point-1;
    loop {
        if i == -1 {
            i = 0;
            break;
        }

        if msrc[i] == closeparen { 
            levels += 1;
        }
        if levels == 0 && !racer::is_path_char(msrc.char_at(i)) {
            i += 1;
            break;
        }
        if msrc[i] == openparen && levels > 0 { 
            levels -= 1;
        }

        i -= 1;
    }
    return i;
}

pub fn expand_search_expr(msrc: &str, point: uint) -> (uint,uint) {
    let start = get_start_of_search_expr(msrc, point);
    return (start, racer::find_ident_end(msrc, point));
}

#[test]
fn expand_search_expr_finds_ident() {
    assert_eq!((0, 7), expand_search_expr("foo.bar", 5))
}

#[test]
fn expand_search_expr_handles_chained_calls() {
    assert_eq!((0, 20), expand_search_expr("yeah::blah.foo().bar", 18))
}

#[test]
fn expand_search_expr_handles_inline_closures() {
    assert_eq!((0, 24), expand_search_expr("yeah::blah.foo(||{}).bar", 22))
}
#[test]
fn expand_search_expr_handles_a_function_arg() {
    assert_eq!((5, 25), expand_search_expr("myfn(foo::new().baz().com)", 23))
}

#[test]
fn expand_search_expr_handles_pos_at_end_of_search_str() {
    assert_eq!((0, 7), expand_search_expr("foo.bar", 7))
}

pub fn mask_comments(src: &str) -> String {
    let mut result = String::new();
    let space = " ";

    let mut prev: uint = 0;
    for (start, end) in codecleaner::code_chunks(src) {
        for _ in ::std::iter::range(prev, start) {
            result.push_str(space);
        }
        result.push_str(src.slice(start,end));
        prev = end;
    }
    return result;
}

pub fn end_of_next_scope<'a>(src: &'a str) -> &'a str {
    let mut levels = 0i;
    let mut end = 0;
    for (i,c) in src.char_indices() {
        if c == '}' {
            levels -= 1;
            if levels == 0 { 
                end = i + 1;
                break;
            }
        } else if c == '{' {
            levels += 1;
        }
    }
    return src.slice_to(end);
}

pub fn coords_to_point(src: &str, mut linenum: uint, col: uint) -> uint {
    let mut point=0;
    for line in src.lines() {
        linenum -= 1;
        if linenum == 0 { break }
        point+=line.len() + 1;  // +1 for the \n
    }
    return point + col;
}

pub fn point_to_coords(src:&str, point:uint) -> (uint, uint) {
    let mut i = 0;
    let mut linestart = 0;
    let mut nlines = 1;  // lines start at 1
    while i != point {
        if src.char_at(i) == '\n' {
            nlines += 1;
            linestart = i+1;
        }
        i+=1;
    }
    return (nlines, point - linestart);
}

pub fn point_to_coords2(path: &Path, point:uint) -> Option<(uint, uint)> {
    let mut lineno = 0;
    let mut file = BufferedReader::new(File::open(path));
    let mut p = 0;
    for line_r in file.lines() {
        let line = line_r.unwrap();
        lineno += 1;
        if point < (p + line.len()) {
            return Some((lineno, point - p));
        }
        p += line.len();
    }
    return None;
}


#[test]
fn coords_to_point_works() {
    let src = "
fn myfn() {
    let a = 3;
    print(a);
}";
    assert!(coords_to_point(src, 3, 5) == 18);
}

#[test]
fn test_scope_start() {
    let src = "
fn myfn() {
    let a = 3;
    print(a);
}
";
    let point = coords_to_point(src, 4, 10);
    let start = scope_start(src,point);
    assert!(start == 12);
}

#[test]
fn test_scope_start_handles_sub_scopes() {
    let src = "
fn myfn() {
    let a = 3;
    {
      let b = 4;
    }
    print(a);
}
";
    let point = coords_to_point(src, 7, 10);
    let start = scope_start(src,point);
    assert!(start == 12);
}



#[test]
fn masks_out_comments() {
    let src = "
this is some code
this is a line // with a comment
some more
";
    let r = mask_comments(src);
    
    assert!(src.len() == r.len());
    // characters at the start are the same
    assert!(src[5] == r.as_slice()[5]);
    // characters in the comments are masked
    let commentoffset = coords_to_point(src,3,23);
    assert!(r.as_slice().char_at(commentoffset) == ' ');
    assert!(src[commentoffset] != r.as_slice()[commentoffset]);
    // characters afterwards are the same 
    assert!(src[src.len()-3] == r.as_slice()[src.len()-3]);
}

#[test]
fn test_point_to_coords() {
    let src = "
fn myfn(b:uint) {
   let a = 3;
   if b == 12 {
       let a = 24;
       do_something_with(a);
   }
   do_something_with(a);
}
";
    round_trip_point_and_coords(src, 4, 5);
}

pub fn round_trip_point_and_coords(src:&str, lineno:uint, charno:uint) {
    let (a,b) = point_to_coords(src, coords_to_point(src, lineno, charno));
     assert_eq!((a,b),(lineno,charno));
}

#[test]
fn finds_end_of_struct_scope() {
    let src="
struct foo {
   a: uint,
   blah: ~str
}
Some other junk";

    let expected="
struct foo {
   a: uint,
   blah: ~str
}";
    let s = end_of_next_scope(src);
    assert_eq!(expected, s);
}

