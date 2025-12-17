#!/bin/bash

# Script to update all inventory-related files to use the new entity structure

echo "Updating all inventory-related files..."

# Update inventory_list_screen.dart
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/inventory/presentation/screens/inventory_list_screen.dart

# Update inventory_detail_screen.dart  
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/inventory/presentation/screens/inventory_detail_screen.dart

# Update inventory_item_detail_screen.dart
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/inventory/presentation/screens/inventory_item_detail_screen.dart

# Update inventory_details_screen.dart
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/inventory/presentation/pages/inventory_details_screen.dart

# Update booking files
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/booking/presentation/screens/booking_item_screen.dart
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/booking/presentation/screens/booking_flow_item_selection.dart

# Update owner dashboard
sed -i 's/item\.imageUrl/item.primaryImage/g' lib/features/owner_dashboard/presentation/screens/owner_inventory_manage_screen.dart

echo "Basic property updates completed. Manual fixes needed for constructor calls and new properties."

