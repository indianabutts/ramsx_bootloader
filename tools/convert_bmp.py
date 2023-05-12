
character_set_raw = []
with open("../assets/font.bmp", 'rb') as image_file:
    image_file.seek(54)
    data = image_file.read(1)
    character_index = 0
    row_index = 0
    while(data):
        character_set_raw.append(data)
        data = image_file.read(1)

print(len(character_set_raw))
for i in range(8):
    print("{:08b}".format(int(character_set_raw[0+16*i].hex(),16)))

    
