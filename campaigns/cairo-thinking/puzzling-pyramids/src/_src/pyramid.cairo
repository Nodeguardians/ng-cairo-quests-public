struct Chamber<T> {
    item: T,
    lower_chambers: Option<(usize, usize)>
}

struct Pyramid<T> {
    top: usize,
    chambers: Array<Chamber<T>>
}

impl ChamberDrop<T, impl TDrop: Drop<T>> of Drop<Chamber<T>>;
impl PyramidDrop<T, impl TDrop: Drop<T> > of Drop<Pyramid<T>>;
