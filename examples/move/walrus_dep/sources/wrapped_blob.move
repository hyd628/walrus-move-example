module walrus_dep::wrapped_blob {
    use blob_store::blob;
    use blob_store::system::{System};
    use sui::coin::{Coin};
    use sui::sui::{SUI};
    use sui::bcs;

    const RED_STUFF: u8 = 0;


/*
    public struct WrappedBlob has key {
        id: UID,
        blob: Blob,
    }

    public fun wrap(blob: Blob, ctx: &mut TxContext): WrappedBlob {
        WrappedBlob { id: object::new(ctx), blob }
    }

*/

    #[allow(lint(self_transfer))]
    public fun write(system_obj: &mut System<SUI>, payment: Coin<SUI>, ctx: &mut TxContext) {
        let root_hash_vec = vector[
            1, 2, 3, 4, 5, 6, 7, 8,
            1, 2, 3, 4, 5, 6, 7, 8,
            1, 2, 3, 4, 5, 6, 7, 8,
            1, 2, 3, 4, 5, 6, 7, 8,
        ];

        let mut encode = bcs::new(root_hash_vec);
        let root_hash = bcs::peel_u256(&mut encode);
        
        let (storage, change) = system_obj.reserve_space<SUI>(10_000_000, 3, payment, ctx);
        let blob_id = blob::derive_blob_id(root_hash, RED_STUFF, 10000);
        let blob1 = blob::register(system_obj, storage, blob_id, root_hash, 10000, RED_STUFF, ctx);

/*
        // BCS confirmation message for epoch 0 and blob id `blob_id` with intents
        let confirmation = vector[
            1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0,
            119, 174, 25, 167, 128, 57, 96, 1, 163, 56, 61, 132,
            191, 35, 44, 18, 231, 224, 79, 178, 85, 51, 69, 53, 214,
            95, 198, 203, 56, 221, 111, 83
        ];

        // Signature from private key scalar(117) on `confirmation`
        let signature = vector[
            184, 138, 78, 92, 221, 170, 180, 107, 75, 249, 222, 177, 183, 25, 107, 214, 237,
            214, 213, 12, 239, 65, 88, 112, 65, 229, 225, 23, 62, 158, 144, 67, 206, 37, 148,
            1, 69, 64, 190, 180, 121, 153, 39, 149, 41, 2, 112, 69, 23, 68, 69, 159, 192, 116,
            41, 113, 21, 116, 123, 169, 204, 165, 232, 70, 146, 1, 175, 70, 126, 14, 20, 206,
            113, 234, 141, 195, 218, 52, 172, 56, 78, 168, 114, 213, 241, 83, 188, 215, 123,
            191, 111, 136, 26, 193, 60, 246
        ];
        //let certify_message = blob::certify_blob_message(blob::Cersystem_obj.epoch(), blob_id);
        //blob::certify_with_certified_msg(&system_obj, certify_message, &mut blob1);

        blob::certify(system_obj, &mut blob1, signature, vector[0], confirmation);
*/
        transfer::public_transfer(blob1, tx_context::sender(ctx));
        //transfer::public_transfer(storage, tx_context::sender(ctx));
        transfer::public_transfer(change, tx_context::sender(ctx));
    }

}
