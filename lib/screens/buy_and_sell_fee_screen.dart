import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/fee_model.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/buy_and_sell_fee.dart';

class BuyAndSellFeeScreen extends StatefulWidget {
  final String title;
  final FeeType feeType;

  BuyAndSellFeeScreen({
    @required this.title,
    @required this.feeType,
  });

  @override
  _BuyAndSellFeePageState createState() => _BuyAndSellFeePageState();
}

class _BuyAndSellFeePageState extends State<BuyAndSellFeeScreen> {
  bool _edit = false;

  _toggleEdit(flag) {
    setState(() {
      _edit = flag;
    });
  }

  _updateFees(context, Map<TradingOption, dynamic> feeControllers) async {
    await Provider.of<FeeConfigProvider>(
      context,
      listen: false,
    ).updateFeeConfigItems(
      widget.feeType,
      feeControllers.map(
        (key, value) {
          var controllers = value as Map<String, TextEditingController>;
          BuySellModel model = BuySellModel();
          model.buy =
              FeeModel(percent: controllers['buy'].text.convertToDouble());
          model.sell =
              FeeModel(percent: controllers['sell'].text.convertToDouble());
          return MapEntry(key, model);
        },
      ),
    );
  }

  _buildActionWidgets(Map<TradingOption, dynamic> feesControllers) {
    if (!_edit) {
      return [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _toggleEdit(true),
        )
      ];
    }
    return [
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () async {
          await _updateFees(context, feesControllers);
          _toggleEdit(false);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeConfigProvider>(
      builder: (_, fp, __) {
        Map<TradingOption, dynamic> feesControllers =
            _buildTextEditingControllers(fp.feeConfig[widget.feeType]);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(widget.title),
            actions: _buildActionWidgets(feesControllers),
          ),
          body: Column(
            children: [
              Expanded(
                child: BuyAndSellFee(
                  feeType: widget.feeType,
                  editMode: _edit,
                  fees: feesControllers,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildTextEditingControllers(Map<TradingOption, dynamic> data) {
    Map<TradingOption, dynamic> fees = {};
    if (null != data) {
      data.forEach((key, value) {
        BuySellModel model = value as BuySellModel;
        fees[key] = {
          'buy': TextEditingController(text: model.buy.percent.toString()),
          'sell': TextEditingController(text: model.sell.percent.toString())
        };
      });
    }
    return fees;
  }
}
