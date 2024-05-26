class assembler():
    def __init__(self,instruction_set,asp):
        if asp:
            self.asp=asp
        else:
            raise Exception("Assempler file is not given")
        if instruction_set:
            self.instruction_set=instruction_set
        else:
            raise Exception("instruction set file is not given")
        self.mi=['org','end','dec','hex']
    def instructin_extreaction(self,path):
        try:
            with open(path, 'r') as f:
                t = [s.rstrip().lower().split() for s in f.readlines()]
            return {opcode:binary for opcode,binary in t}
        except FileNotFoundError:
            raise Exception("the file "+ path + " does not exist.")
    def assemp_file(self):
        try:
            with open(self.asp, 'r') as f:
                self.asmp=[s.rstrip().lower().split() for s in f.readlines()]
        except FileNotFoundError:
            raise Exception("the file "+ self.asp + " does not exist.")
    def remove_comment(self):
        for i in range(len(self.asmp)):
            for j in range(len(self.asmp[i])):
                if self.asmp[i][j].startswith('/'):
                    del self.asmp[i][j:]
                    break
    def assemb(self):
        self.ins_dic=self.instructin_extreaction(self.instruction_set)
        self.assemp_file()
        self.remove_comment()
        self.first_pass()
        self.secound_pass()
        print("The Assemble completed Succesfully")
    def first_pass(self):
        self.label={}
        LC=0
        for i in range(len(self.asmp)):
            if self.asmp[i]!=[]:
                if self.asmp[i][0].endswith(','):
                    self.label[self.asmp[i][0][0:-1]]=str(LC)
                    del self.asmp[i][0]
                    LC +=1
                elif self.asmp[i][0]=='org':
                    LC=int(self.asmp[i][1],16)
                elif self.asmp[i][0]=='end':
                    break
                else:
                    LC +=1
            else:
                del self.asmp[i]
    def secound_pass(self):
        with open("Machine_Code.txt", 'w') as f:
            LC=0
            for i in self.asmp:
                if i[0] in self.mi:
                    if i[0]=='org':
                        LC=int(i[1],16)
                    elif i[0]=='end':
                        break
                    elif i[0]=='dec':
                        f.write(bin(LC).replace('0b','').zfill(4))
                        f.write("  ")
                        if int(i[1])>=0:
                            f.write(bin(int(i[1])).replace('0b','').zfill(8))
                        else:
                            f.write(bin(int(i[1])& 0b11111111).replace('0b',''))
                        f.write("\n")
                        LC+=1
                    elif i[0]=='hex':
                        f.write(bin(LC).replace('0b','').zfill(4))
                        f.write("  ")
                        if int(i[1],16)>=0:
                            f.write('{:b}'.format(int(i[1], 16)).zfill(8))
                        else:
                            f.write(bin(int(i[1],16)& 0b11111111).replace('0b',''))
                        f.write("\n")
                        LC+=1
                elif i[0] in self.ins_dic:
                    f.write(bin(LC).replace('0b','').zfill(4))
                    f.write("  ")
            
                    if i[0] =='ret' or i[0] =='out' or i[0] =='hlt':
                        f.write(self.ins_dic[i[0]])
                        f.write('{:b}'.format(int(0)).zfill(4))
                        f.write("\n")
                        LC+=1
                    else:
                        f.write(self.ins_dic[i[0]])
                        f.write('{:b}'.format(int(self.label[i[1]])).zfill(4))
                        f.write("\n")
                        LC+=1
                else:
                    print('Problem in line {}'.format(LC))
                    f.write("Unvalid syntax")
                    f.write("\n")
                    LC+=1

asp=assembler( instruction_set= "insterction_set.txt",asp= "asm.txt")
asp.assemb()