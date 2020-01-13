/* Return The Largest Number from an array */

var myArray = [1,2,3,9,5];

function returnLargeNumber(arr){
    arrLen = arr.length;
    var larNum = 0;
    for(i=0;i<arrLen;i++){
        if(arr[i]>larNum){
            larNum = arr[i];
        }
    }
    return larNum;
}

largestNumber = returnLargeNumber(myArray);
console.log(largestNumber);
document.getElementById('largeNumber').innerHTML = largestNumber;