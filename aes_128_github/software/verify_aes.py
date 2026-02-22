from Crypto.Cipher import AES
from binascii import unhexlify, hexlify

# --- 1. THE KEY (Matches your Verilog) ---
key_hex = "2b7e151628aed2a6abf7158809cf4f3c"
key = unhexlify(key_hex)

# --- 2. THE 4 BLOCKS (From your image.mem) ---
# Block 1: Row 0 + Row 1
block1_hex = "7f8383838e9088868c8d8c8c96938c8b"
# Block 2: Row 2 + Row 3
block2_hex = "95939b8a77928f8f9b999b625c939797"
# Block 3: Row 4 + Row 5
block3_hex = "a19ea76a6d969c9da197b8a5829b9d9d"
# Block 4: Row 6 + Row 7
block4_hex = "9e98969d9b9d9d9c9d999796989a9c9c"

blocks = [block1_hex, block2_hex, block3_hex, block4_hex]

# --- 3. SETUP AES (ECB Mode) ---
cipher = AES.new(key, AES.MODE_ECB)

print(f"{'BLOCK':<8} | {'INPUT (From image.mem)':<34} | {'EXPECTED OUTPUT (Check tx_data)':<34}")
print("-" * 85)

# --- 4. CALCULATE & PRINT ---
for i, b_hex in enumerate(blocks):
    data_bytes = unhexlify(b_hex)
    encrypted_bytes = cipher.encrypt(data_bytes)
    encrypted_hex = hexlify(encrypted_bytes).decode('utf-8')
    
    print(f"Block {i+1:<2} | {b_hex:<34} | {encrypted_hex:<34}")