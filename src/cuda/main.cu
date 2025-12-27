__global__ void kernel(int* a) {

  *a = 5;
}

extern "C" int mainCuda(void) {
  int *a, b;
  cudaMalloc(&a, sizeof(int));
  kernel<<<1, 1>>>(a);
  cudaDeviceSynchronize();
  cudaMemcpy(&b, a, sizeof(int), cudaMemcpyDeviceToHost);
  cudaFree(a);
  return b;
}
