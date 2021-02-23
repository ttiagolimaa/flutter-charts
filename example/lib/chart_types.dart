import 'package:flutter/material.dart';
import 'package:flutter_charts/chart.dart';

import 'charts/bar_chart_screen.dart';
import 'charts/bubble_chart_screen.dart';
import 'charts/candle_chart_screen.dart';

class ChartTypes extends StatelessWidget {
  const ChartTypes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Bar chart'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4].map((e) => BarValue<void>(e.toDouble())).toList(),
                    axisMax: 9,
                  ),
                  itemOptions: BarItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    radius: BorderRadius.vertical(top: Radius.circular(12.0)),
                    color: Theme.of(context).accentColor,
                    maxBarWidth: 8.0,
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 1,
                      horizontalAxisStep: 1.5,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => BarChartScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Bubble chart'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4].map((e) => BubbleValue<void>(e.toDouble())).toList(),
                    axisMax: 9,
                  ),
                  itemOptions: BubbleItemOptions(
                    color: Theme.of(context).accentColor,
                    maxBarWidth: 8.0,
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 3,
                      horizontalAxisStep: 3,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => BubbleChartScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Candle chart'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4].map((e) => CandleValue<void>(e.toDouble() + 6, e.toDouble())).toList(),
                    axisMax: 15,
                  ),
                  itemOptions: BarItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    radius: BorderRadius.all(Radius.circular(12.0)),
                    color: Theme.of(context).accentColor,
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 1,
                      horizontalAxisStep: 3,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => CandleChartScreen()));
          },
        ),
        Divider(),
      ],
    );
  }
}
