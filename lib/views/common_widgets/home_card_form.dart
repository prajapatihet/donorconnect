import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCardConst extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color col;

  const HomeCardConst({
    super.key,
    required this.title,
    required this.onPressed,
    required this.col,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: width * 0.40,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(30),
          color: col,
          onPressed: onPressed,
          padding: const EdgeInsets.all(4),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
