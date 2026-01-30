import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/characters/presentation/store/characters_store.dart';

class FiltersSection extends StatefulWidget {
  final CharactersStore store;

  const FiltersSection({super.key, required this.store});

  @override
  State<FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.filter_list, color: AppColors.accent),
                title: const Text(
                  'Filters',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.store.hasActiveFilters)
                      TextButton(
                        onPressed: widget.store.clearFilters,
                        child: const Text('Clear All'),
                      ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.accent,
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              if (_isExpanded) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterGroup(
                        'Gender',
                        ['male', 'female', 'unknown'],
                        widget.store.selectedGender,
                        widget.store.setGenderFilter,
                      ),
                      const SizedBox(height: 16),
                      _buildFilterGroup(
                        'Status',
                        ['alive', 'dead', 'unknown'],
                        widget.store.selectedStatus,
                        widget.store.setStatusFilter,
                      ),
                      const SizedBox(height: 16),
                      _buildFilterGroup(
                        'Species',
                        [
                          'human',
                          'robot',
                          'alien',
                          'mutant',
                          'head',
                          'monster',
                          'unknown',
                        ],
                        widget.store.selectedSpecies,
                        widget.store.setSpeciesFilter,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterGroup(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(
                option.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? AppColors.textOnSecondary
                      : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.secondary,
              checkmarkColor: AppColors.textOnSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.secondary : Colors.transparent,
                  width: 2,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
