/// This is a as-is temporal Mutex wrapper. by 06/06
use core::{
    cell::UnsafeCell,
    default::Default,
    fmt,
    ops::{Deref, DerefMut},
    sync::atomic::{AtomicBool, Ordering},
};

pub struct Mutex<T: ?Sized> {
    data: UnsafeCell<T>,
}
pub struct MutexGuard<'a, T: ?Sized> {
    data: &'a mut T,
}

impl<T> Mutex<T> {
    #[inline(always)]
    pub const fn new(data: T) -> Self {
        Mutex {
            data: UnsafeCell::new(data),
        }
    }
    #[inline(always)]
    pub fn lock(&self) -> MutexGuard<T> {
        MutexGuard {
            data: unsafe { &mut *self.data.get() },
        }
    }
}

// impl<T: ?Sized + Default> Default for Mutex<T> {
//     fn default() -> Self {
//         Mutex::new(T::default())
//     }
// }

impl<'a, T: ?Sized> Deref for MutexGuard<'a, T> {
    type Target = T;
    fn deref(&self) -> &T {
        self.data
    }
}

impl<'a, T: ?Sized> DerefMut for MutexGuard<'a, T> {
    fn deref_mut(&mut self) -> &mut T {
        self.data
    }
}