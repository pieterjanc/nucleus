fn main() {
    println!("cargo:rustc-link-arg=--library-path=src");
    println!("cargo:rustc-link-arg=--script=link.ld");
    println!("cargo:rerun-if-changed=src/link.ld");
}
