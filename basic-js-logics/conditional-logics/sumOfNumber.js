function getSum(a,b){
    let higher,lower;
    let result = 0;

    if(a == b){
        return a;
    }
    else{
        if(a > b){
            higher = a;
            lower = b;            
        }
        else{
            higher = b;
            lower = a;
        }
       for(i=lower;i<=higher;i++){
           result += i;
       }
    }
    return result;
}

sumValue = getSum(3,9);
console.log(sumValue)
document.getElementById('sumofNum').innerHTML = sumValue;