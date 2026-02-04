List<double> score(List<double> input) {
    List<double> var0;
    if (input[3] <= 0.5) {
        var0 = [1.0, 0.0];
    } else {
        if (input[3] <= 1.5) {
            if (input[2] <= 37.33181381225586) {
                var0 = [1.0, 0.0];
            } else {
                var0 = [0.0, 1.0];
            }
        } else {
            var0 = [0.0, 1.0];
        }
    }
    List<double> var1;
    if (input[2] <= 37.50063514709473) {
        var1 = [1.0, 0.0];
    } else {
        var1 = [0.0, 1.0];
    }
    List<double> var2;
    if (input[2] <= 37.499977111816406) {
        var2 = [1.0, 0.0];
    } else {
        var2 = [0.0, 1.0];
    }
    List<double> var3;
    if (input[2] <= 37.50057411193848) {
        var3 = [1.0, 0.0];
    } else {
        var3 = [0.0, 1.0];
    }
    List<double> var4;
    if (input[3] <= 0.5) {
        var4 = [1.0, 0.0];
    } else {
        if (input[2] <= 37.305335998535156) {
            var4 = [1.0, 0.0];
        } else {
            var4 = [0.0, 1.0];
        }
    }
    List<double> var5;
    if (input[2] <= 37.50063514709473) {
        var5 = [1.0, 0.0];
    } else {
        var5 = [0.0, 1.0];
    }
    List<double> var6;
    if (input[1] <= 10.5) {
        if (input[2] <= 37.49530601501465) {
            var6 = [1.0, 0.0];
        } else {
            var6 = [0.0, 1.0];
        }
    } else {
        var6 = [1.0, 0.0];
    }
    List<double> var7;
    if (input[1] <= 10.5) {
        if (input[3] <= 0.5) {
            var7 = [1.0, 0.0];
        } else {
            var7 = [0.0, 1.0];
        }
    } else {
        var7 = [1.0, 0.0];
    }
    List<double> var8;
    if (input[1] <= 10.5) {
        if (input[2] <= 37.500051498413086) {
            var8 = [1.0, 0.0];
        } else {
            var8 = [0.0, 1.0];
        }
    } else {
        var8 = [1.0, 0.0];
    }
    List<double> var9;
    if (input[3] <= 0.5) {
        var9 = [1.0, 0.0];
    } else {
        if (input[1] <= 58.5) {
            var9 = [0.0, 1.0];
        } else {
            var9 = [1.0, 0.0];
        }
    }
    return mulVectorNumber(addVectors(addVectors(addVectors(addVectors(addVectors(addVectors(addVectors(addVectors(addVectors(var0, var1), var2), var3), var4), var5), var6), var7), var8), var9), 0.1);
}
List<double> addVectors(List<double> v1, List<double> v2) {
    List<double> result = new List<double>.filled(v1.length, 0.0);
    for (int i = 0; i < v1.length; i++) {
        result[i] = v1[i] + v2[i];
    }
    return result;
}
List<double> mulVectorNumber(List<double> v1, double num) {
    List<double> result = new List<double>.filled(v1.length, 0.0);
    for (int i = 0; i < v1.length; i++) {
        result[i] = v1[i] * num;
    }
    return result;
}
