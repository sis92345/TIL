# Javascript 객체 순환 참조로 인한 Stringify 오류 문제

# 1. Error Message

VM440:5 Uncaught TypeError: Converting circular structure to JSON
    --> starting at object with constructor 'Object'
    |     property 'asdd' -> object with constructor 'Object'
    --- property 'asdd' closes the circle
    at JSON.stringify (<anonymous>)

# 2. Error Code

```javascript
const obj1 = { asd : "" }
const obj2 = { asd2 : "" }
obj1.asdd = obj2 ;
obj2.asdd = obj1;
JSON.stringify( obj1  ) 
```

# 3. 원인

순환 참조란 참조하는 대상이 서로 물려 있어서 참조할 수 없게 되는 현상을 말한다. 이번 오류는 Javascript Object가 순환참조를 하고 있어서 JSON으로 변환할 수 없었던 문제였다. **Javscript의 JSON.stringify()는 순환 참조를 하는 객체를 JSON으로 변환할 수 없다.**

# 4. 해결

순환참조를 하는 property를 변경하거나 제거해서 순환 참조를 막으면 된다.

```javascript
delete obj1.asdd
JSON.stringify( obj1  ) 
```



