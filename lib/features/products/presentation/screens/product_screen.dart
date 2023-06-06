import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/provider/providers.dart';


import '../../../shared/widgets/widgets.dart';
import '../../domain/domain.dart';



class ProductScreen extends ConsumerWidget {

  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar( title: const Text('Editar Produto'), 
      actions: [
        IconButton(onPressed: (){

        }, 
        icon: const Icon( Icons.camera_alt_outlined))
      ],
      ),
      
      body:  productState.isLoading 
        ? const FullScreenLoader()
        : _ProductView(product: productState.product!),
      floatingActionButton: FloatingActionButton(
        onPressed: (){}, 
        child: const Icon( Icons.save_as_outlined)
      ),
    );
  }
}


class _ProductView extends ConsumerWidget {

  final ProductEntity product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch( productFormProvider(product) );

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
    
          SizedBox(
            height: 250,
            width: 600,
            child: _ImageGallery(images: productForm.images ),
          ),
    
          const SizedBox( height: 10 ),
          Center(child: Text( productForm.title.value, style: textStyles.titleSmall )),
          const SizedBox( height: 10 ),
          _ProductInformation( product: product ),
          
        ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {

  final ProductEntity product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

   final productForm = ref.watch( productFormProvider(product) );
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: ref.read( productFormProvider(product).notifier ).onTitleChanges,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField( 
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: ref.read( productFormProvider(product).notifier ).onSlugChanges,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField( 
            isBottomField: true,
            label: 'Price',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged:(value) => ref.read( productFormProvider(product).notifier)
             .onPriceChanges(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15 ),
          const Text('sizes'),

          _SizeSelector(
            selectedSizes: productForm.sizes, 
            onSizesChanged: ref.read( productFormProvider(product).notifier).onSizeChanged,
           ),
          const SizedBox(height: 5 ),
          _GenderSelector( 
            selectedGender: productForm.gender, 
            onGenderChanged: ref.read( productFormProvider(product).notifier).onGenderChanged,
           ),
          

          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Existents',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged:(value) => ref.read( productFormProvider(product).notifier )
              .onStockChanges(int.tryParse(value) ?? -1),
            errorMessage: productForm.inStock.errorMessage,
          ),

          CustomProductField( 
            maxLines: 6,
            label: 'Description',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: ref.read( productFormProvider(product).notifier).onDescriptionChanged
          ),

          CustomProductField( 
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: ref.read( productFormProvider(product).notifier).onTagsChanged
          ),


          const SizedBox(height: 100 ),
        ],
      ),
    );
  }
}


class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];

  final void Function(List<String> selectedSizes) onSizesChanged;
 
  const _SizeSelector({required this.selectedSizes, required this.onSizesChanged});


  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size, 
          label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(), 
      selected: Set.from( selectedSizes ),
      onSelectionChanged: (newSelection) {
        onSizesChanged( List.from(newSelection) );
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;

  final void Function( String selectedGender) onGenderChanged;

  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];



  const _GenderSelector({required this.selectedGender, required this.onGenderChanged});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon( genderIcons[ genders.indexOf(size) ] ),
            value: size, 
            label: Text(size, style: const TextStyle(fontSize: 12))
          );
        }).toList(), 
        selected: { selectedGender },
        onSelectionChanged: (newSelection) {
          onGenderChanged(newSelection.first);
        },
      ),
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.7
      ),
      children: images.isEmpty
        ? [ ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover )) 
        ]
        : images.map((e){
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.network(e, fit: BoxFit.cover,),
          );
      }).toList(),
    );
  }
}