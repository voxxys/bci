/*
 * _coder_toCtest_api.c
 *
 * Code generation for function '_coder_toCtest_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "toCtest.h"
#include "_coder_toCtest_api.h"

/* Function Definitions */
void toCtest_api(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Invoke the target function */
  toCtest(&st);
}

/* End of code generation (_coder_toCtest_api.c) */
