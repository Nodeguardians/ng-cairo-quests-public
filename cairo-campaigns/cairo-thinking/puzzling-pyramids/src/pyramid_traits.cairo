use array::ArrayTrait;
use clone::Clone;
use option::OptionTrait;

use src::pyramid::Pyramid;
use src::pyramid::Chamber;

// ╔════════════════════════════════════════════╗
// ║         HELPER CLASS: PyramidSlice         ║
// ╚════════════════════════════════════════════╝

struct PyramidSlice<T> {
    top: usize,
    chambers: @Array<Chamber<T>>
}

impl PyramidSliceDrop<T, impl TDrop: Drop<T> > of Drop<PyramidSlice<T>>;

trait PyramidSliceTrait<T> {
    fn from(pyramid: @Pyramid<T>) -> PyramidSlice<T>;
    fn top_item(self: @PyramidSlice<T>) -> T;
    fn is_bottommost(self: @PyramidSlice<T>) -> bool;
    fn lower(self: @PyramidSlice<T>) -> (PyramidSlice<T>, PyramidSlice<T>);
}

impl PyramidSliceImpl<T, impl TClone: Clone<T>, impl TDrop: Drop<T>> of PyramidSliceTrait<T> {

    fn from(pyramid: @Pyramid<T>) -> PyramidSlice<T> {
        PyramidSlice {
            top: *pyramid.top,
            chambers: pyramid.chambers
        }
    }

    fn is_bottommost(self: @PyramidSlice<T>) -> bool {
        (*self.chambers)[*self.top].lower_chambers.is_none()
    }

    fn top_item(self: @PyramidSlice<T>) -> T {
        (*self.chambers)[*self.top].item.clone()
    }

    fn lower(self: @PyramidSlice<T>) -> (PyramidSlice<T>, PyramidSlice<T>) {
        let top_chamber = (*self.chambers)[*self.top];
        match top_chamber.lower_chambers {
            Option::Some((left, right)) => {
                let left_chamber = PyramidSlice { top: *left, chambers: *self.chambers };
                let right_chamber = PyramidSlice { top: *right, chambers: *self.chambers };

                (left_chamber, right_chamber)
            },
            Option::None(_) => panic_with_felt252('No lower chambers')
        }
    }

}

// ╔════════════════════════════════════════════╗
// ║         PART #1: Into<Pyramid, Array>      ║
// ╚════════════════════════════════════════════╝

impl PyramidIntoArray<T, impl TClone: Clone<T>, impl TDrop: Drop<T>> of Into<Pyramid<T>, Array<T>> {
    fn into(self: Pyramid<T>) -> Array<T> {
        let mut array = ArrayTrait::new();

        let top_slice = PyramidSliceTrait::from(@self);
        slice_to_array(top_slice, ref array);
        
        array
    }
}

fn slice_to_array<T, impl TClone: Clone<T>, impl TDrop: Drop<T>>(slice: PyramidSlice<T>, ref array: Array<T>) {
    let top_item = slice.top_item();
    if slice.is_bottommost() {
        array.append(top_item);
    } else {
        let (left_slice, right_slice) = slice.lower();
        slice_to_array(left_slice, ref array);
        array.append(top_item);
        slice_to_array(right_slice, ref array);
    }
}

// ╔════════════════════════════════════════════╗
// ║          PART #2: Pyramid Search           ║
// ╚════════════════════════════════════════════╝

trait PyramidSearchTrait<T> {
    fn search(self: @Pyramid<T>, key: T) -> Option<Array<T>>;
}

impl PyramidSearchImpl<T, impl TClone: Clone<T>, impl TDrop: Drop<T>, impl TPartialEq: PartialEq<T>> of PyramidSearchTrait<T> {
    fn search(self: @Pyramid<T>, key: T) -> Option<Array<T>> {

        let self_slice = PyramidSliceTrait::from(self);
        let path_indices = search_path_indices(self_slice, @key);

        match path_indices {
            Option::Some(index_array) => {
                let mut item_array = ArrayTrait::new();
                let mut i = index_array.len() - 1;

                loop {
                    let index = *index_array[i];
                    let item = self.chambers[index].item;
                    item_array.append(item.clone());

                    if (i == 0) { break (); }
                    i -= 1;
                };

                Option::Some(item_array)
            },
            Option::None(_) => Option::None(())
        }

    }
}

fn search_path_indices<T, impl TClone: Clone<T>, impl TDrop: Drop<T>, impl TPartialEq: PartialEq<T>>(
    self: PyramidSlice<T>, 
    key: @T
) -> Option<Array<usize>> {

    if (self.top_item().clone() == key.clone()) {
        let mut new_array = ArrayTrait::new();
        new_array.append(self.top);

        return Option::Some(new_array);
    }
    
    if (self.is_bottommost()) {
        return Option::None(());
    }

    let (left_slice, right_slice) = self.lower();
    
    let search_left = search_path_indices(left_slice, key);
    if search_left.is_some() {
        let mut array = search_left.unwrap();
        array.append(self.top);

        return Option::Some(array);
    }

    let search_right = search_path_indices(right_slice, key);
    if search_right.is_some() {
        let mut array = search_right.unwrap();
        array.append(self.top);

        return Option::Some(array);
    }

    Option::None(())

}
