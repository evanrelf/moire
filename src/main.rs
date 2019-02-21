fn main() {
    let args: Vec<String> = std::env::args().collect();

    let input_filename: &String = &args[1];
    let output_filename: &String = &args[2];

    let dot_color: [u8; 3] = [0, 0, 0];
    let dot_size: u32 = 1;
    let dot_distance: u32 = 5;

    if dot_size >= dot_distance {
        panic!("Distance must be smaller than size");
    }

    let mut img: image::RgbImage = image::open(input_filename)
        .expect(&format!("Failed to open '{}'", input_filename))
        .to_rgb();

    for (x, y, pixel) in img.enumerate_pixels_mut() {
        if ((x % dot_distance) < dot_size) && ((y % dot_distance) < dot_size) {
            *pixel = image::Rgb(dot_color);
        }
    }

    img.save(output_filename)
        .expect(&format!("Failed to save '{}'", output_filename));
}
