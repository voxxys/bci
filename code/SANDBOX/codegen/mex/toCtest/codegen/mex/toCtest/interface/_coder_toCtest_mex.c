/*
 * _coder_toCtest_mex.c
 *
 * Code generation for function 'toCtest'
 *
 */

/* Include files */
#include "mex.h"
#include "_coder_toCtest_api.h"
#include "toCtest_initialize.h"
#include "toCtest_terminate.h"

/* Function Declarations */
static void toCtest_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "toCtest", NULL, false, {2045744189U,2170104910U,2743257031U,4284093946U}, NULL };
void *emlrtRootTLSGlobal = NULL;

/* Function Definitions */
static void toCtest_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  emlrtStack st = { NULL, NULL, NULL };
  /* Module initialization. */
  toCtest_initialize(&emlrtContextGlobal);
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, mxINT32_CLASS, 0, mxCHAR_CLASS, 7, "toCtest");
  } else if (nlhs > 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, mxCHAR_CLASS, 7, "toCtest");
  }
  /* Call the function. */
  toCtest_api();
  /* Module finalization. */
  toCtest_terminate();
}

void toCtest_atexit_wrapper(void)
{
   toCtest_atexit();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(toCtest_atexit_wrapper);
  /* Dispatch the entry-point. */
  toCtest_mexFunction(nlhs, plhs, nrhs, prhs);
}
/* End of code generation (_coder_toCtest_mex.c) */
