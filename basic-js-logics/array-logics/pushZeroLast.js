var zeroArray = [1,3,0,0,1,3,0,0,5];


function pushZero(arr){
   
    let count = 0;  
        for (let i = 0; i < arr.length; i++) {
            if (arr[i] !== 0) arr[count++] = arr[i]; 
        }

        while (count < arr.length) arr[count++] = 0;

        return arr;
}



zeroLast = pushZero(zeroArray);
console.log(zeroLast);
document.getElementById('lastZero').innerHTML = zeroLast;
