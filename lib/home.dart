import 'package:flutter/material.dart';
import 'package:json_api_integration/modelclass/UserModeL.dart';
import 'package:json_api_integration/network/api_caller.dart';
import 'package:json_api_integration/network/apis.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<User> users = <User>[];
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];

  @override
  void initState() {
    super.initState();
    ApiCaller.get(Apis.users).then((res) {
      final datalist = List.from(res);
      setState(() {
        for (var d in datalist) {
          final userModel = User.fromJson(d);
          users.add(userModel);
          _createAnimation(users.length - 1);  // Create animation for each item
        }
        _startAnimations();
      });
    }).catchError((error) {
      print("Error: $error");
    });
  }

  void _createAnimation(int index) {
    // Create an animation controller for each item
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Create a sliding animation from left to right
    final animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),  // Starts from the left offscreen
      end: Offset(0.0, 0.0),    // Ends at the original position
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    _controllers.add(controller);
    _animations.add(animation);
  }

  void _startAnimations() async {
    for (int i = 0; i < users.length; i++) {
      await Future.delayed(Duration(milliseconds: 300));  // Delay between each item
      _controllers[i].forward();  // Start the animation for each item
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return SlideTransition(
            position: _animations[index],  // Apply sliding animation
            child: Card(
              color: Colors.orange,
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    enabled: true,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${user.name[0]}',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(user.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    subtitle: user.isExpanded
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${user.id}'),
                        Text('Username: ${user.username}'),
                        Text('Phone: ${user.phone}'),
                        Text('Website: ${user.website}'),
                        Text(
                            'Address:\n\t\t\t\t\tStreet: ${user.address.street}\n\t\t\t\t\tSuite: ${user.address.suite}\n\t\t\t\t\tCity: ${user.address.city}\n\t\t\t\t\tZipcode: ${user.address.zipcode}'),
                        Text(
                            'Company:\n\t\t\t\t\tName: ${user.company.name}\n\t\t\t\t\tCatchphrase: ${user.company.catchPhrase}\n\t\t\t\t\tBS: ${user.company.bs}'),
                      ],
                    )
                        : Text(user.email),
                    trailing: IconButton(
                      icon: Icon(
                        user.isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
                      onPressed: () {
                        setState(() {
                          user.isExpanded = !user.isExpanded;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
