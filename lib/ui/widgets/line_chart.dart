import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:uniris_mobile_wallet/appstate_container.dart';
import 'package:uniris_mobile_wallet/styles.dart';

class LineChartWidget {
  List<FlSpot> data = [];
  double minY = 0;
  double minX = 0;
  double maxY = 0;
  double maxX = 0;

  static Widget buildTinyCoinsChart(BuildContext context) {
    if (StateContainer.of(context).chartInfos != null &&
        StateContainer.of(context).chartInfos.data != null) {
      return Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: BoxDecoration(
                color: StateContainer.of(context).curTheme.backgroundDark,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        StateContainer.of(context).curTheme.backgroundDarkest,
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(
                    mainData(context),
                  )),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5.0),
              child: Text(
                'UCO (1d)',
                style: AppStyles.textStyleTransactionUnit(context),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 100.0),
                child: StateContainer.of(context)
                            .chartInfos
                            .priceChangePercentage24h! >=
                        0
                    ? Row(
                        children: [
                          Text(
                            StateContainer.of(context)
                                    .chartInfos
                                    .priceChangePercentage24h!
                                    .toStringAsFixed(2) +
                                "%",
                            style: AppStyles.textStyleChartGreen(context),
                          ),
                          Icon(Entypo.up_dir,
                              color: StateContainer.of(context)
                                  .curTheme
                                  .positiveValue),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            StateContainer.of(context)
                                    .chartInfos
                                    .priceChangePercentage24h!
                                    .toStringAsFixed(2) +
                                "%",
                            style: AppStyles.textStyleChartRed(context),
                          ),
                          Icon(Entypo.down_dir,
                              color: StateContainer.of(context)
                                  .curTheme
                                  .negativeValue),
                        ],
                      )),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
                decoration: BoxDecoration(
                  color: StateContainer.of(context).curTheme.backgroundDark,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          StateContainer.of(context).curTheme.backgroundDarkest,
                      blurRadius: 5.0,
                      spreadRadius: 0.0,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: Center(child: CircularProgressIndicator()),
                )),
          ),
        ],
      );
    }
  }

  static LineChartData mainData(BuildContext context) {
    List<Color> gradientColors = [
      StateContainer.of(context).curTheme.backgroundDark,
      StateContainer.of(context).curTheme.backgroundDarkest,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: StateContainer.of(context).curTheme.backgroundDarkest,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: StateContainer.of(context).curTheme.backgroundDarkest,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 10,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          reservedSize: 10,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: StateContainer.of(context).chartInfos.minX,
      maxX: StateContainer.of(context).chartInfos.maxX,
      minY: StateContainer.of(context).chartInfos.minY,
      maxY: StateContainer.of(context).chartInfos.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: StateContainer.of(context).chartInfos.data,
          isCurved: true,
          colors: gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
