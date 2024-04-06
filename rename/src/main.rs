use std::ffi::{OsStr, OsString};
use std::io::stdin;
use std::path::{Path, PathBuf};
use std::{fs, io};

fn collect_files(dir: &Path) -> io::Result<Vec<PathBuf>> {
    let mut files: Vec<PathBuf> = vec![];

    if dir.is_dir() {
        for entry in fs::read_dir(dir)? {
            let entry = entry?;
            let path = entry.path();
            if path.is_dir() {
                files.append(&mut collect_files(&path)?);
            } else {
                files.push(path)
            }
        }
    }
    Ok(files)
}

fn rename(file: &Path) -> PathBuf {
    // ./art\\21-07\\01 - Destiny Ghost.png
    // ./art\\21-07-01 Destiny Ghost.png

    let count = file.iter().count();

    // Store the left part
    let left = file.iter().take(count - 2);
    let mut right = file
        .iter()
        .skip(count - 2)
        .map(|x| x.to_owned())
        .collect::<Vec<_>>();

    // Process the name, we want to change remove any " - " naming things
    let name = right[1].to_str().unwrap();
    let name: String = name
        .split("-")
        .map(|x| x.trim())
        .fold(String::new(), |acc, x| {
            if acc.is_empty() {
                acc + x
            } else {
                acc + " " + x
            }
        });
    right[1] = OsString::from(name.to_lowercase());

    // Join the date and name date
    let right = right.iter().fold(String::new(), |acc, x| {
        if acc.is_empty() {
            acc + x.to_str().unwrap()
        } else {
            acc + "-" + x.to_str().unwrap()
        }
    });

    // Return the entire thing summarized
    left.chain(std::iter::once(OsStr::new(&right)))
        .fold(PathBuf::new(), |mut acc, x| {
            acc.push(x);
            acc
        })
}

fn main() {
    let target = "./art";
    let files = collect_files(Path::new(target)).unwrap();

    files
        .iter()
        .for_each(|x| println!("{:?} -> {:?}", x, rename(x)));

    println!("Press enter to continue...");
    let mut s = String::new();
    stdin().read_line(&mut s).unwrap();

    files.iter().for_each(|x| fs::rename(x, rename(x)).unwrap())
}
