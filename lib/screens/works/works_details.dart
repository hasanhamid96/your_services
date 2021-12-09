import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_services/model/person_work.dart';

class DoctorWorksDetails extends StatelessWidget {
  static String routeName = "Doctor_Works_Details";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final worksDoctor = ModalRoute.of(context).settings.arguments as PersonWork;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'الملف',
        middle: Text('${worksDoctor.title}',
            style: Theme.of(context).textTheme.headline5),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                worksDoctor.imageUrl,
                errorBuilder: (context, error, stackTrace) =>
                    loadingImage(mediaQuery, 1),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return loadingImage(mediaQuery, 0);
                },
                width: mediaQuery.width,
                height: mediaQuery.height * 0.4,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  worksDoctor.title,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(worksDoctor.description,
                    style: Theme.of(context).textTheme.headline1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container loadingImage(Size mediaQuery, int typeOfLoading) {
    return Container(
        color: Colors.white,
        width: mediaQuery.width,
        height: mediaQuery.height * 0.4,
        child: typeOfLoading == 0
            ? Center(child: CircularProgressIndicator.adaptive())
            : Icon(Icons.broken_image_rounded));
  }
}
