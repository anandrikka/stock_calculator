import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcalculator/providers/fee_config_provider.dart';
import 'package:stockcalculator/utils/enums.dart';
import 'package:stockcalculator/widgets/settings/fee_widget_utils.dart';

class GstScreen extends StatefulWidget {
  @override
  _GstScreenState createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  var _gstController = TextEditingController();
  var _edit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('GST'),
        actions: _buildActionItems(context),
      ),
      body: Container(
        height: 55,
        padding: EdgeInsets.only(
          left: 8.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Percent (%)',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Consumer<FeeConfigProvider>(
              builder: (_, fcp, __) {
                _gstController.text = fcp.gst.toString();
                return SizedBox(
                  width: 120,
                  child: buildTextInput(
                    controller: _gstController,
                    context: context,
                    editMode: _edit,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _toggleEdit(bool flag) {
    setState(() {
      _edit = flag;
    });
  }

  _buildActionItems(BuildContext context) {
    if (_edit) {
      return [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            await Provider.of<FeeConfigProvider>(
              context,
              listen: false,
            ).updateGst(
              FeeType.GST,
              _gstController.text,
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
}
