import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyStateContainer(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black, // Set primary color to black
        appBarTheme: AppBarTheme(
          color: Colors.purple
              .shade300, // Set app bar color to a slightly darker shade of purple
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple, // Set primary swatch to purple
        ).copyWith(
          background: Colors.purple
              .shade100, // Set lighter shade of purple for background color
        ),
      ),
      home: HomePage(),
    );
  }
}

class MyAppState extends InheritedWidget {
  final MyStateContainerState data;

  MyAppState({Key? key, required Widget child, required this.data})
      : super(key: key, child: child);

  static MyStateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyAppState>()
            as MyAppState)
        .data;
  }

  @override
  bool updateShouldNotify(MyAppState oldWidget) {
    return true;
  }
}

class MyStateContainer extends StatefulWidget {
  final Widget child;

  MyStateContainer({required this.child});

  @override
  MyStateContainerState createState() => MyStateContainerState();
}

class MyStateContainerState extends State<MyStateContainer> {
  List<ProductItem> cart = [];

  void addToCart(Product product, [int quantity = 1]) {
    setState(() {
      // Check if the product is already in the cart
      var existingItemIndex =
          cart.indexWhere((item) => item.product.name == product.name);

      // If the product is already in the cart, increase its quantity
      if (existingItemIndex != -1) {
        cart[existingItemIndex].quantity += quantity;
      } else {
        // Otherwise, add it to the cart with the specified quantity
        cart.add(ProductItem(product: product, quantity: quantity));
      }
    });
  }

  void removeFromCart(ProductItem item) {
    setState(() {
      cart.remove(item);
    });
  }

  void changeQuantity(ProductItem item, int newQuantity) {
    setState(() {
      item.quantity = newQuantity;
    });
  }

  double calculateSubtotal() {
    return cart.fold(
        0, (subtotal, item) => subtotal + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return MyAppState(
      data: this,
      child: widget.child,
    );
  }
}

class ProductItem {
  final Product product;
  int quantity;

  ProductItem({required this.product, required this.quantity});
}

class Product {
  final String name;
  final double price;
  final String imageUrl; // Could be a local file path or a URL
  final String? description;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the button width (90% of the screen width)
    double buttonWidth = screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              'Welcome to Our Tattoo Website!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrowseTattoosPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(buttonWidth, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Browse Tattoos',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrowseProductsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(buttonWidth, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Browse Tattoo Care Products',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpertPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(buttonWidth, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Talk to an Expert',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Navigate to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}

class Tattoo {
  final String imageUrl;
  final String type; // 'blackwork' or 'colorwork'
  final String description;
  final Expert expert;

  Tattoo({
    required this.imageUrl,
    required this.type,
    required this.description,
    required this.expert,
  });
}

class BrowseTattoosPage extends StatefulWidget {
  @override
  _BrowseTattoosPageState createState() => _BrowseTattoosPageState();
}

class _BrowseTattoosPageState extends State<BrowseTattoosPage> {
  List<Tattoo> tattoos = [
    Tattoo(
      imageUrl: 'assets/images/tattoo1.png',
      type: 'Blackwork',
      description: 'This is a blackwork tattoo.',
      expert: Expert(
        name: 'Arun Pendyala',
        expertise: 'Blackwork',
        phoneNumber: '123-654-7890',
        email: 'Arun.Pendyala@gmail.com',
      ),
    ),
    Tattoo(
      imageUrl: 'assets/images/tattoo2.png',
      type: 'Blackwork',
      description: 'This is a blackwork tattoo.',
      expert: Expert(
        name: 'Arun Pendyala',
        expertise: 'Blackwork',
        phoneNumber: '123-654-7890',
        email: 'Arun.Pendyala@gmail.com',
      ),
    ),
    Tattoo(
      imageUrl: 'assets/images/tattoo3.png',
      type: 'Blackwork',
      description: 'This is a blackwork tattoo.',
      expert: Expert(
        name: 'Arun Pendyala',
        expertise: 'Blackwork',
        phoneNumber: '123-654-7890',
        email: 'Arun.Pendyala@gmail.com',
      ),
    ),
    Tattoo(
      imageUrl: 'assets/images/tattoo4.png',
      type: 'Blackwork',
      description: 'This is a blackwork tattoo.',
      expert: Expert(
        name: 'Arun Pendyala',
        expertise: 'Blackwork',
        phoneNumber: '123-654-7890',
        email: 'Arun.Pendyala@gmail.com',
      ),
    ),
    Tattoo(
      imageUrl: 'assets/images/colorwork1.png',
      type: 'Colorwork',
      description: 'This is a colorwork tattoo.',
      expert: Expert(
        name: 'John Doe',
        expertise: 'Colorwork',
        phoneNumber: '123-456-7890',
        email: 'John.Doe@gmail.com',
      ),
    ),
    Tattoo(
      imageUrl: 'assets/images/colorwork2.png',
      type: 'Colorwork',
      description: 'This is a colorwork tattoo.',
      expert: Expert(
        name: 'John Doe',
        expertise: 'Colorwork',
        phoneNumber: '123-456-7890',
        email: 'John.Doe@gmail.com',
      ),
    ),
    // Add more tattoos as needed
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    List<Tattoo> filteredTattoos = _selectedFilter == 'All'
        ? tattoos
        : tattoos.where((tattoo) => tattoo.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Tattoos'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
            items: ['All', 'Blackwork', 'Colorwork']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: filteredTattoos.length,
        itemBuilder: (context, index) {
          final tattoo = filteredTattoos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TattooDetailsPage(tattoo: tattoo),
                ),
              );
            },
            child: Image.asset(tattoo.imageUrl, fit: BoxFit.cover),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Navigate to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}

class TattooDetailsPage extends StatelessWidget {
  final Tattoo tattoo;

  TattooDetailsPage({required this.tattoo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tattoo Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(tattoo.imageUrl),
            SizedBox(height: 16.0),
            Text(
              'Type: ${tattoo.type}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${tattoo.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Expert: ${tattoo.expert.name}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Expertise: ${tattoo.expert.expertise}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Phone Number: ${tattoo.expert.phoneNumber}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Email: ${tattoo.expert.email}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}

class BrowseProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = MyAppState.of(context); // Obtain the state container
    var products = [
      Product(
        name: 'Tattoo Ink Bundle',
        price: 260.00,
        imageUrl: 'assets/images/ink.png',
        description:
            'This 25 color set is comprised of Solid Ink\'s, most essentials inks when it comes to having a dynamic palette.',
      ),
      Product(
        name: 'Tattoo Needles',
        price: 10.49,
        imageUrl: 'assets/images/needle.png',
        description:
            'Color lock cartridge tattoo needles are specifically designed by industry professionals to help artists create sharp, clear, and precise tattoos.',
      ),
      Product(
        name: 'Dermashield Bandage',
        price: 34.99,
        imageUrl: 'assets/images/bandage.png',
        description:
            'Give your tattoos the easy, healthy recovery they deserve with Recovery Derm Shield',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Tattoo Care Products'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.yellowAccent, // Choose a color for the background
            child: Text(
              'Special Offer: Get 10% off per unit when you purchase 5 or more of the same item!',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle:
                      Text('\$${products[index].price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      container.addToCart(
                          products[index]); // Add the product to the cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to Cart')),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsPage(product: products[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Navigate to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}

// Talk to an expert portion
class Expert {
  final String name;
  final String expertise;
  final String phoneNumber;
  final String email;

  Expert({
    required this.name,
    required this.expertise,
    required this.phoneNumber,
    required this.email,
  });
}

class ExpertPage extends StatelessWidget {
  final List<Expert> experts = [
    Expert(
      name: 'John Doe',
      expertise: 'Colorwork',
      phoneNumber: '123-456-7890',
      email: 'John.Doe@gmail.com',
    ),
    Expert(
      name: 'Jane Doe',
      expertise: 'Tattoo Care',
      phoneNumber: '321-456-7890',
      email: 'Jane.Doe@gmail.com',
    ),
    Expert(
      name: 'Arun Pendyala',
      expertise: 'Blackwork',
      phoneNumber: '123-654-7890',
      email: 'Arun.Pendyala@gmail.com',
    ),
    // Add more experts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk to an Expert'),
      ),
      body: ListView.builder(
        itemCount: experts.length,
        itemBuilder: (context, index) {
          final expert = experts[index];
          return ListTile(
            title: Text(
              expert.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expertise: ${expert.expertise}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Phone Number: ${expert.phoneNumber}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Email: ${expert.email}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Navigate to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = MyAppState.of(context);
    var cart = container.cart;
    var subtotal = container.calculateSubtotal();
    var tax = subtotal * 0.064; // 6.4% tax rate
    var total = subtotal + tax;

    bool isCartEmpty = cart.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  var product = cart[index].product;
                  var quantity = cart[index].quantity;
                  var unitPrice = product.price;
                  var totalPrice = unitPrice * quantity;
                  var discount = (quantity >= 5) ? (totalPrice * 0.10) : 0;
                  var discountedPrice = totalPrice - discount;

                  return ListTile(
                    title: Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (discount > 0)
                          const Text(
                            'Discount: 10% off',
                            style:
                                TextStyle(fontSize: 14, color: Colors.indigo),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              container.changeQuantity(
                                  cart[index], quantity - 1);
                            } else {
                              container.removeFromCart(cart[index]);
                            }
                          },
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            container.changeQuantity(cart[index], quantity + 1);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            container.removeFromCart(cart[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(''), // To align the numbers
              ),
              ListTile(
                title: Text(
                  'Tax (6.4%): \$${tax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(''), // To align the numbers
              ),
              ListTile(
                title: Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: Text(''), // To align the numbers
              ),
              SizedBox(height: 16), // Add some space
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isCartEmpty
                        ? null // Disable button if cart is empty
                        : () {
                            // Create a copy of the cart list
                            List<ProductItem> cartCopy = List.from(cart);

                            // Remove all items from the original cart list
                            cartCopy.forEach((cartItem) {
                              container.removeFromCart(cartItem);
                            });
                          },
                    child: Text('Empty Cart'),
                  ),
                  ElevatedButton(
                    onPressed: isCartEmpty
                        ? null // Disable button if cart is empty
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderInfoPage()),
                            );
                          },
                    child: Text('Order Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Do nothing as we are already on the cart page
          }
        },
      ),
    );
  }
}

class OrderInfoPage extends StatefulWidget {
  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  bool useSameInfoForShipping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Billing Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Zip Code'),
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Use same information for shipping'),
                value: useSameInfoForShipping,
                onChanged: (value) {
                  setState(() {
                    useSameInfoForShipping = value!;
                  });
                },
              ),
              if (!useSameInfoForShipping) ...[
                SizedBox(height: 16),
                Text(
                  'Shipping Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'State'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Zip Code'),
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the card details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardDetailsPage()),
                  );
                },
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetailsPage extends StatefulWidget {
  @override
  _CardDetailsPageState createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  String generateConfirmationCode() {
    // Generate a random 6-digit number
    Random random = Random();
    int confirmationCode = random.nextInt(900000) + 100000;
    return confirmationCode.toString();
  }

  final _formKey = GlobalKey<FormState>();

  String? _cardNumber;
  String? _expirationDate;
  String? _cvv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Card Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (!isAlphanumeric(value)) {
                    return 'Card number should be alphanumeric';
                  }
                  return null;
                },
                onSaved: (value) => _cardNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiration Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration date';
                  }
                  // Add your validation logic for expiration date
                  return null;
                },
                onSaved: (value) => _expirationDate = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  if (!isAlphanumeric(value)) {
                    return 'CVV should be alphanumeric';
                  }
                  return null;
                },
                onSaved: (value) => _cvv = value,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String confirmationCode = generateConfirmationCode();
                    _formKey.currentState!.save();
                    // Add payment logic here
                    // For now, just navigate back to the cart page
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Payment Complete!'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Your order confirmation code: $confirmationCode'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Complete Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAlphanumeric(String value) {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(value);
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.asset(
              widget.product.imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Price: \$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var container = MyAppState.of(context);
                container.addToCart(widget.product, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to Cart')),
                );
              },
              child: Text('Add to Cart'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.product.description ?? "No Description",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}
