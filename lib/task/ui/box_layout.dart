import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/helper_c_layout.dart';
import '../bloc/box_bloc.dart';
import '../bloc/box_event.dart';
import '../bloc/box_state.dart';
import '../model/box_model.dart';

class BoxLayoutScreen extends StatefulWidget {
  const BoxLayoutScreen({super.key});

  @override
  State<BoxLayoutScreen> createState() => _BoxLayoutScreenState();
}

class _BoxLayoutScreenState extends State<BoxLayoutScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Interactive C-Layout',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Box Configuration',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Icon(Icons.apps, color: Colors.blue),
                ],
              ),

              SizedBox(height: screenSize.height * 0.03),

              // Input Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenSize.width * 0.03),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter number of boxes (5-25)',
                          labelStyle:
                              TextStyle(fontSize: screenSize.width * 0.035),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenSize.width * 0.02),
                          ),
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: screenSize.height * 0.06,
                        child: ElevatedButton(
                          onPressed: _generateBoxes,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.width * 0.02),
                            ),
                          ),
                          child: Text(
                            'Generate Boxes',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenSize.height * 0.03),

              // Box Layout Section
              SizedBox(
                height: screenSize.height * 0.7,
                child: BlocBuilder<BoxBloc, BoxState>(
                  builder: (context, state) {
                    if (state is BoxInitial) {
                      return _buildEmptyState(screenSize);
                    } else if (state is BoxGenerated) {
                      return _buildBoxLayout(state, screenSize);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_outlined,
            size: screenSize.width * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: screenSize.height * 0.02),
          Text(
            'Enter a number to generate boxes',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                  fontSize: screenSize.width * 0.04,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxLayout(BoxGenerated state, Size screenSize) {
    final grid = CLayoutHelper.generateCShape(state.boxes.length);
    final boxSize = screenSize.width * 0.12;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenSize.width * 0.03),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap boxes to turn green',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: screenSize.width * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (state.isAnimating)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.03,
                      vertical: screenSize.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    child: Text(
                      'Reversing...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),

            // C-Shape Layout Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'C-Shape Layout (${state.boxes.length} boxes)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: screenSize.width * 0.03,
                            color: Colors.grey[600],
                          ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),

                    // Grid Layout
                    ...grid.asMap().entries.map((rowEntry) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.008),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              rowEntry.value.asMap().entries.map((colEntry) {
                            final boxIndex = colEntry.value;

                            if (boxIndex == null) {
                              // Empty space
                              return SizedBox(
                                width: boxSize +
                                    (screenSize.width *
                                        0.02), // Include padding
                                height: boxSize,
                              );
                            }

                            final box = state.boxes[boxIndex];

                            return Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.01),
                              child: _buildBox(
                                  box, boxSize, state.isAnimating, boxIndex),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenSize.height * 0.02),
            SizedBox(
              width: double.infinity,
              height: screenSize.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  context.read<BoxBloc>().add(const ResetBoxes());
                  _controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.02),
                  ),
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(
      BoxModel box, double size, bool isAnimating, int displayIndex) {
    return GestureDetector(
      onTap: isAnimating
          ? null
          : () {
              context.read<BoxBloc>().add(ToggleBox(box.index));
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: box.isGreen ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(size * 0.1),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (box.isGreen ? Colors.green : Colors.red).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (box.clickOrder != null)
                Text(
                  '${box.clickOrder}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                '${displayIndex + 1}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getBoxIndex(List<List<bool>> grid, int row, int col) {
    int index = 0;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j]) {
          if (i == row && j == col) {
            return index;
          }
          index++;
        }
      }
    }
    return 0;
  }

  void _generateBoxes() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final n = int.tryParse(input);
    if (n != null && n >= 5 && n <= 25) {
      context.read<BoxBloc>().add(GenerateBoxes(n));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a number between 5 and 25'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
