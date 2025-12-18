import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/education_provider.dart';

class ProductsGuideScreen extends StatefulWidget {
  const ProductsGuideScreen({super.key});

  @override
  State<ProductsGuideScreen> createState() => _ProductsGuideScreenState();
}

class _ProductsGuideScreenState extends State<ProductsGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final educationProvider = Provider.of<EducationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink, Colors.purple],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.health_and_safety,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Educational Resource',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Period Products Guide',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Learn about different period products',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProductsFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load products',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products available',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Information header
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Educational Resources',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'These products are for educational purposes. Always consult with a healthcare provider for personalized advice. Tap any product to learn about proper usage, safety guidelines, and find what works best for your body.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Medically reviewed information',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '6 Products',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Products grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = products[index];
                    return _buildProductCard(product, theme, educationProvider);
                  }, childCount: products.length),
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    ThemeData theme,
    EducationProvider educationProvider,
  ) {
    final colorValue =
        int.tryParse(product['color'] ?? '0xFFE91E63') ?? 0xFFE91E63;
    final productColor = Color(colorValue);

    return GestureDetector(
      onTap: () => _showProductDetails(product, educationProvider),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: productColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: productColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and rating
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    productColor.withOpacity(0.1),
                    productColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: productColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getProductIcon(product['type']),
                      color: productColor,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '${product['rating'] ?? 4.5}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown Product',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product['category'] ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: productColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        product['description'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Learn More',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: productColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: productColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getProductIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'pad':
        return Icons.favorite;
      case 'tampon':
        return Icons.circle;
      case 'cup':
        return Icons.local_drink;
      case 'disc':
        return Icons.album;
      case 'liner':
        return Icons.rectangle;
      default:
        return Icons.health_and_safety;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchProductsFromFirebase() async {
    try {
      // TODO: Replace with actual Firebase Firestore query
      // This is a mock implementation for now
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      return [
        {
          'id': '1',
          'name': 'Sanitary Pads (Disposable)',
          'category': 'Pads',
          'type': 'pad',
          'rating': 4.8,
          'color': '0xFFE91E63',
          'description':
              'Most common period product - absorbent pads that stick to your underwear to collect menstrual blood. Available in different absorbencies for light to heavy flow days.',
          'instructions': '''How to Use Sanitary Pads:
1. Wash your hands before handling
2. Remove the pad from its wrapper
3. Peel off the adhesive backing strip
4. Place the sticky side down on the inside of your underwear (center the pad)
5. If it has wings, wrap them around the sides of your underwear
6. Change every 4-6 hours (more frequently on heavy flow days)
7. Never wear the same pad for more than 8 hours
8. Wrap used pads in toilet paper or the wrapper and dispose in a bin (never flush)

💡 Tips:
• Start with regular absorbency and adjust based on your flow
• Use overnight pads while sleeping for extra protection
• Carry spares in your bag for emergencies
• Track how often you change to understand your flow pattern''',
          'features': [
            'Easy to use - Great for beginners',
            'No insertion required',
            'Available in various absorbencies',
            'Can be worn with any underwear',
            'Disposable - No cleaning needed',
          ],
          'sizes': ['Light', 'Regular', 'Super', 'Overnight', 'Maxi'],
        },
        {
          'id': '2',
          'name': 'Menstrual Cup',
          'category': 'Cups',
          'type': 'cup',
          'rating': 4.9,
          'color': '0xFF9C27B0',
          'description':
              'Reusable silicone cup inserted into the vagina to collect (not absorb) menstrual blood. Can be worn for up to 12 hours. Eco-friendly and cost-effective long-term option.',
          'instructions': '''How to Use a Menstrual Cup:

Before First Use:
• Sterilize the cup by boiling it in water for 5-7 minutes
• Wash your hands thoroughly

Insertion:
1. Find a comfortable position (sitting, squatting, or standing with one leg raised)
2. Fold the cup (try C-fold or punch-down fold)
3. Relax your muscles
4. Hold the folded cup and gently insert it into your vagina at a 45-degree angle (toward your tailbone, not straight up)
5. Once inside, release the fold and let the cup pop open
6. Run your finger around the base to ensure it's fully opened and sealed
7. The cup should sit lower than a tampon, just inside the vaginal opening

Removal:
1. Wash your hands
2. Relax and find a comfortable position
3. Bear down with your pelvic muscles
4. Pinch the base (not the stem) to break the seal
5. Gently pull the cup out while keeping it upright
6. Empty contents into toilet
7. Rinse with water and reinsert
8. At end of period, sterilize by boiling

⏰ Timing: Empty every 4-12 hours depending on flow
💡 Learning Curve: May take 2-3 cycles to master - be patient!

Safety Notes:
• Always break the seal before removal
• Never pull by the stem alone
• If you can't reach it, relax and try again later - it can't get lost''',
          'features': [
            'Reusable - Lasts up to 10 years',
            'Cost-effective in long run',
            'Eco-friendly - Zero waste',
            'Can wear up to 12 hours',
            'No odor or dryness',
            'Safe for overnight use',
          ],
          'sizes': [
            'Small (under 30 or no births)',
            'Large (over 30 or after childbirth)'
          ],
        },
        {
          'id': '3',
          'name': 'Tampons',
          'category': 'Tampons',
          'type': 'tampon',
          'rating': 4.6,
          'color': '0xFF673AB7',
          'description':
              'Cylindrical absorbent product inserted into the vagina to absorb menstrual blood. Available with or without applicators. Popular for swimming and active lifestyles.',
          'instructions': '''How to Use Tampons:

Preparation:
• Wash your hands thoroughly
• Choose the right absorbency (start with regular)
• Find a comfortable position (sitting on toilet, squatting, or standing with one leg raised)
• Relax - tension makes insertion harder

With Applicator:
1. Unwrap the tampon and extend the applicator if it's telescopic
2. Hold the grip (middle of applicator) with thumb and middle finger
3. Locate your vaginal opening (use a mirror if needed)
4. Gently insert the applicator at a 45-degree angle toward your lower back (not straight up)
5. Push until your fingers touch your body
6. Press the inner tube to release the tampon
7. Remove the applicator, leaving the string hanging outside
8. If you can feel it, it's not inserted far enough - try again with a new one

Without Applicator:
1. Unwrap and hold the tampon at its base
2. Insert with your index finger at a 45-degree angle
3. Push until your finger is fully inserted
4. The string should hang outside

Removal:
1. Wash your hands
2. Relax your muscles
3. Gently pull the string downward and forward
4. Wrap in toilet paper and dispose in bin (NEVER flush)

⏰ Change Schedule:
• Every 4-8 hours maximum
• NEVER exceed 8 hours
• Change before swimming or sports
• Use lowest absorbency for your flow

⚠️ CRITICAL TSS WARNING:
Toxic Shock Syndrome (TSS) is a rare but life-threatening condition linked to tampon use.

TSS Symptoms - Seek medical help immediately if you experience:
• Sudden high fever (39°C/102°F or higher)
• Vomiting or diarrhea
• Dizziness or fainting
• Rash resembling sunburn
• Muscle aches
• Confusion

Prevention:
• Use the lowest absorbency needed
• Change regularly (never exceed 8 hours)
• Wash hands before insertion
• Alternate with pads (especially overnight)
• Never use tampons between periods

💡 First-Time Tips:
• Practice when you're calm, not rushing
• Use a mirror to see what you're doing
• Try during heavier flow days (easier insertion)
• Use lowest absorbency until comfortable
• It's normal to take a few tries!''',
          'features': [
            'Discreet and comfortable when worn correctly',
            'Can swim and exercise freely',
            'Available with/without applicator',
            'Various absorbencies available',
            'String for easy removal',
          ],
          'sizes': ['Light', 'Regular', 'Super', 'Super Plus'],
        },
        {
          'id': '4',
          'name': 'Menstrual Disc',
          'category': 'Discs',
          'type': 'disc',
          'rating': 4.7,
          'color': '0xFF3F51B5',
          'description':
              'Flexible disc that sits at the base of the cervix (vaginal fornix) to collect menstrual blood. Different from cups - sits higher and can be worn during sex. Holds more fluid than cups.',
          'instructions': '''How to Use Menstrual Disc:

Before Use (Reusable discs):
• Sterilize by boiling for 5-7 minutes
• Wash hands thoroughly

Insertion:
1. Find a comfortable position (sitting, squatting, or standing)
2. Squeeze the disc in half to create a narrow figure-8 or taco shape
3. Separate your labia with your free hand
4. Insert the disc into your vagina, aiming toward your tailbone
5. Push it back and down as far as it will go
6. Tuck the front rim up behind your pubic bone
7. You should feel it "click" or settle into place
8. Run your finger around the edge to ensure proper placement

You've Done It Right When:
• You can't feel it at all
• It sits at the widest part of the vaginal canal
• The front rim is behind your pubic bone

Removal:
1. Wash your hands
2. Sit on the toilet or squat
3. Insert your finger and hook it under the front rim
4. Pull gently forward and down
5. Keep it level to avoid spills
6. Empty into toilet
7. Rinse and reinsert (or dispose if disposable)

⏰ Wear Time: Up to 12 hours
🔄 Reusable discs can last years with proper care

💡 Key Differences from Cups:
• Sits higher (at cervix, not in vaginal canal)
• Doesn't use suction
• Can be worn during penetrative sex
• Usually holds more fluid
• May be easier to empty without full removal

Tips for Success:
• Requires more practice than cups
• Try during heavy flow first
• Use a mirror initially
• May take 2-3 cycles to master
• Some people find discs more comfortable than cups

Note: Not suitable during all types of intercourse - discuss with partner''',
          'features': [
            'Holds more than cups - Up to 5-6 tampons worth',
            '12-hour wear time',
            'Can be worn during sex',
            'No suction - Easier removal for some',
            'Reusable options available',
            'Often more comfortable than cups',
          ],
          'sizes': ['One size fits most', 'Some brands offer 2 sizes'],
        },
        {
          'id': '5',
          'name': 'Panty Liners',
          'category': 'Liners',
          'type': 'liner',
          'rating': 4.4,
          'color': '0xFF2196F3',
          'description':
              'Very thin, lightweight pads for light discharge, spotting, or backup protection. Much thinner than regular pads - designed for everyday freshness or very light flow days.',
          'instructions': '''How to Use Panty Liners:

When to Use:
• Light flow days (start or end of period)
• Spotting between periods
• Backup protection with tampons/cups/discs
• Daily vaginal discharge
• Post-sex discharge protection
• First period (not sure when it will start)

How to Use:
1. Wash your hands
2. Remove liner from wrapper
3. Peel off adhesive backing
4. Place sticky side down in the center of underwear
5. If it has wings, fold them around the sides
6. Change every 3-6 hours or as needed
7. Wrap used liner and dispose in bin (never flush)

💡 Usage Tips:
• Not suitable for heavy flow - Use pads instead
• Can cause irritation if worn too long
• Choose breathable/cotton options when possible
• Don't use as a substitute for pads during periods
• Useful when learning to use cups/discs (backup)

⚠️ Health Note:
• Don't wear liners 24/7 - Give your body breaks
• Excessive use can disrupt natural vaginal pH
• If you have heavy daily discharge, see a healthcare provider
• Change frequently to prevent bacterial growth''',
          'features': [
            'Ultra-thin and discreet',
            'Comfortable for all-day wear',
            'Prevents underwear staining',
            'Ideal for light days',
            'Good backup protection',
            'Breathable options available',
          ],
          'sizes': ['Regular', 'Long', 'Extra Long'],
        },
        {
          'id': '6',
          'name': 'Reusable Cloth Pads',
          'category': 'Pads',
          'type': 'pad',
          'rating': 4.5,
          'color': '0xFF009688',
          'description':
              'Washable, reusable fabric pads that snap around underwear. Eco-friendly and cost-effective alternative to disposable pads. Made from absorbent layers of cotton, bamboo, or microfiber.',
          'instructions': '''How to Use Reusable Cloth Pads:

Before First Use:
• Wash 2-3 times to increase absorbency
• Follow care instructions for your specific brand
• Prep at least 8-12 pads for a full cycle

During Your Period:
1. Snap the pad around the gusset of your underwear
2. Wings snap underneath to hold it in place
3. Change every 3-6 hours depending on flow
4. Store used pads in a wet bag or container until washing

Storage Methods for Used Pads:
• Wet bag (waterproof bag for used pads)
• Container with lid
• Rinse first if preferred, then store
• Don't leave wet pads sealed for more than 2 days

Washing Instructions:
1. Pre-rinse in cold water to remove blood (optional but helpful)
2. Store in wet bag until laundry day
3. Wash in cold water first, then warm/hot
4. Use mild, eco-friendly detergent
5. Avoid fabric softeners (reduces absorbency)
6. Avoid bleach (damages fibers)
7. Sun-dry for natural sanitizing and stain removal
8. Or tumble dry on low heat

Stain Removal Tips:
• Rinse immediately after use
• Soak in cold water before washing
• Sunlight naturally bleaches stains
• Hydrogen peroxide for stubborn stains
• Don't worry - stains don't affect function!

💰 Cost Savings:
• Initial investment: \$100-150 for full set
• Lasts 5-7 years with proper care
• Saves \$50-100 per year on disposables

🌍 Environmental Impact:
• One person uses 5,000-15,000 pads in a lifetime
• Cloth pads eliminate this waste completely
• Takes 500-800 years for disposable pads to decompose

💡 Best For:
• Sensitive skin (no chemicals)
• Heavy flow (more absorbent options)
• Overnight use (wider, longer pads available)
• Budget-conscious over time
• Environmentally conscious choices

⚠️ Considerations:
• Requires access to water and soap
• Need storage for used pads when out
• Initial cost is higher
• Not ideal for travel without laundry access
• Requires comfort with handling menstrual blood''',
          'features': [
            'Reusable - Lasts 5-7 years',
            'Eco-friendly - Zero waste',
            'Cost-effective long term',
            'Chemical-free materials',
            'Softer and more breathable',
            'No plastic against skin',
            'Multiple absorbencies available',
            'Cute patterns and colors',
          ],
          'sizes': ['Light', 'Regular', 'Heavy', 'Overnight', 'Postpartum'],
        },
      ];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  void _showProductDetails(
    Map<String, dynamic> product,
    EducationProvider educationProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          final theme = Theme.of(context);
          final colorValue =
              int.tryParse(product['color'] ?? '0xFFE91E63') ?? 0xFFE91E63;
          final productColor = Color(colorValue);

          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        productColor.withOpacity(0.1),
                        productColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: productColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getProductIcon(product['type']),
                          color: productColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? 'Unknown Product',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${product['rating'] ?? 4.5}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Educational disclaimer
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.school, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Educational resource - Always consult healthcare providers for personalized advice',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // How to Use
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: productColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'How to Use',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: productColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: productColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          product['instructions'] ??
                              'No instructions available.',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features
                      Text(
                        'Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...((product['features'] as List<dynamic>?) ?? []).map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: productColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sizes
                      if (product['sizes'] != null &&
                          (product['sizes'] as List).isNotEmpty) ...[
                        Text(
                          'Available Sizes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: (product['sizes'] as List<dynamic>)
                              .map(
                                (size) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: productColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: productColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    size.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: productColor,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Mark as viewed button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            educationProvider.recordResourceViewed(
                              product['id'] ?? '',
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added to your learning progress!',
                                ),
                                backgroundColor: productColor,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: productColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Mark as Learned',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
