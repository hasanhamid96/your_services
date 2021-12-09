import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/screens/bottomScreens/setionsScreen.dart';
import 'package:your_services/widgets/personList.dart';

class SectionItem extends StatelessWidget {
  Section section;
  SectionItem({Key key, @required this.city_id, this.section})
      : super(key: key);

  final int city_id;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: InkWell(
          radius: 30,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Provider.of<Sections>(context,listen: false).fetchSections()
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => PersonList(
                      city_id: city_id,
                      section_id: section.id,
                    )));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: GridTile(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: section.image,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Image.asset('assets/images/sssssss.png'),
                  )),
              footer: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: GridTileBar(
                  backgroundColor: Colors.blue[400].withOpacity(0.4),
                  title: Center(
                    child: Text(
                      '${section.title}',
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
