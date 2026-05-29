int smin(int *arr, unsigned int size) { 
    if (size == 0) 
        return 0; 
    
    int min = arr[0];
    for (unsigned int i = 0; i < size; i++) { 
        if (arr[i] < min) 
            min = arr[i];
    } 
    
    return min; 
}