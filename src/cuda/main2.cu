__global__ void kernel2(int* a) {

  *a = 5;
}

extern "C" int mainCuda2(void) {
  int *a, b;
  cudaMalloc(&a, sizeof(int));
  kernel2<<<1, 1>>>(a);
  cudaDeviceSynchronize();
  cudaMemcpy(&b, a, sizeof(int), cudaMemcpyDeviceToHost);
  cudaFree(a);
  return b;
}
