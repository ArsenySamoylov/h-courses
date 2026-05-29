class VecReg<bits<4> hw, string n, string p, int sz> {
  bits<4> HWEncoding = hw;
  string Name = n;
  string purpose = p;
  int Size = sz;
}

def D1 : VecReg<{0,0,0,1}, "d1", "GPR", 64>;
def D2 : VecReg<{0,0,1,0}, "d2", "VEC", 64>;
def D3 : VecReg<{0,0,1,1}, "d3", "VEC", 64>;
def D4 : VecReg<{0,1,0,0}, "d4", "VEC", 64>;

def Q1 : VecReg<{0,0,0,1}, "q1", "VEC", 128>;
def Q2 : VecReg<{0,0,1,0}, "q2", "VEC", 128>;
def Q3 : VecReg<{0,0,1,1}, "q3", "VEC", 128>;
def Q4 : VecReg<{0,1,0,0}, "q4", "VEC", 128>;
