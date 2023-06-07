use bitflags::bitflags;

bitflags! {
    /// See
    pub struct PTEFlags: u8 {
        const VALID = 1 << 0;
        const READ = 1 << 1;
        const WRITE = 1 << 2;
        const EXECUTE = 1 << 3;
        const USER = 1 << 4;
        const GLOBAL = 1 << 5;
        const ACCESS = 1 << 6;
        const DIRTY = 1 << 7;
    }
}