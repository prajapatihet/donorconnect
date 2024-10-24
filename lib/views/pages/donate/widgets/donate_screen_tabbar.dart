import 'package:donorconnect/Utils/constants/images_string.dart';
import 'package:donorconnect/views/common_widgets/donate_card.dart';
import 'package:donorconnect/views/common_widgets/donor_card.dart';
import 'package:donorconnect/views/common_widgets/rounded_conatiner.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common_widgets/rounded_image.dart';

class DonateScreenTabbar extends StatelessWidget {
  const DonateScreenTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarExample();
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: TabBarView(
          children: <Widget>[
            NestedTabBar(''),
            NestedTabBar(''),
            NestedTabBar(''),
          ],
        ),
      
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs:  <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Urgent'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
            TDonateCardHorizontal(),
             TDonateCardHorizontal(),

            ],
          ),
        ),
      ],
    );
  }
}