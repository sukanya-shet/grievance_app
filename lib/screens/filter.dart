import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/screens/category_setting.dart';
import 'package:grievance_app/screens/home/home.dart';
import 'package:grievance_app/utils/colors.dart';

final categories = [
  CategoryOption(categoryName: 'Sanitation'),
  CategoryOption(categoryName: 'Security'),
  CategoryOption(categoryName: 'Sewage'),
  CategoryOption(categoryName: 'Road query'),
  CategoryOption(categoryName: 'Infrastructure'),
];

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter"),
          backgroundColor: mobileThemeColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Category",
                style: TextStyle(
                    color: mobileThemeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              CategoryFilter(),
            ],
          ),
        ));
  }
}

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 215, 212, 212),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categories[index].categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                  child: Checkbox(
                      value: categories[index].value,
                      onChanged: (value) {
                        setState() {
                          final newValue = !categories[index].value;
                          categories[index].value = newValue;
                          print(categories[index].value);
                        }
                      }),
                )
              ],
            ),
          );
        });
  }
}
