import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/models/fee_model.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/single_fee.dart';

class SingleFeeScreen extends StatefulWidget {
  final String title;
  final FeeType feeType;

  SingleFeeScreen({
    @required this.title,
    @required this.feeType,
  });

  @override
  _SingleFeePageState createState() => _SingleFeePageState();
}

class _SingleFeePageState extends State<SingleFeeScreen> {
  bool _edit = false;

  _toggleEdit(flag) {
    setState(() {
      _edit = flag;
    });
  }

  _buildActionItems(
      BuildContext context, Map<TradingOption, dynamic> controllers) {
    if (_edit) {
      return [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            await Provider.of<FeeConfigProvider>(
              context,
              listen: false,
            ).updateFeeConfigItems(
              widget.feeType,
              controllers.map(
                (
                  key,
                  value,
                ) {
                  var controller = value as TextEditingController;
                  FeeModel model = FeeModel(
                    percent: controller.text.convertToDouble(),
                  );
                  return MapEntry(key, model);
                },
              ),
            );
            _toggleEdit(false);
          },
        ),
      ];
    }
    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _toggleEdit(true),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeConfigProvider>(
      builder: (_, fcp, __) {
        Map<TradingOption, dynamic> controllers =
            _buildTextEditingControllers(fcp.feeConfig[widget.feeType]);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(widget.title),
            actions: _buildActionItems(context, controllers),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleFee(
                  feeType: widget.feeType,
                  editMode: _edit,
                  fees: controllers,
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
        FeeModel model = value as FeeModel;
        fees[key] = TextEditingController(text: model.percent.toString());
      });
    }
    return fees;
  }
}
