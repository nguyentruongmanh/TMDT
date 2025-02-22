class Categories {
  String title;
  String image;
  Categories({
    required this.title,
    required this.image,
  });
}
final List<Categories> categories = [
    Categories(title: 'Shoes', image: 'lib/images/categories_image/shoes.png'),
    Categories(title: "Men's clothes", image: 'lib/images/categories_image/clothes-men.png'),
    Categories(title: "Women's clothes", image: 'lib/images/categories_image/clothes-women.png'),
    Categories(title: 'Jewelries', image: 'lib/images/categories_image/jewelry.png'),
    Categories(title: 'Beauty', image: 'lib/images/categories_image/beauty.png'),
];