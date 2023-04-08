public class MyClass{
    public static void main(String args[]){
        MyClass obj = new MyClass();
        int num1, num2, sum;
        num1 = 2;
        num2 = 4;
        sum = num1 + num2;
        obj.display(num1, num2, sum);
    }
    public void display(int n1, int n2, int s){
        System.out.println("The sum of "+n1+" & "+n2+" is "+s);
    }
}