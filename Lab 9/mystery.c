int main (int a) {
    if (a==0) {
        return 0;
    }
	else  {
        return mystery(a-1) + mystery(a-1) + 1;
    }
}
