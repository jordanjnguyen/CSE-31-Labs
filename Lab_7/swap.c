void swap (int *px, int *py) {
	int *temp;
	*temp = *px;
	*px = *py;
	*py = *temp;
}
void proc(int a, int b) {
	int zero = 0;
}
int main () {
	int a = 1, b = 2;
	proc(a, b);
	swap(&a, &b);
}