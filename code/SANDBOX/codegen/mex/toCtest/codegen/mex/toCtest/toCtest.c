/*
 * toCtest.c
 *
 * Code generation for function 'toCtest'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "toCtest.h"

/* Variable Definitions */
static emlrtMCInfo emlrtMCI = { 3, 1, "toCtest",
  "D:\\bci\\code\\SANDBOX\\toCtest.m" };

static emlrtRSInfo emlrtRSI = { 3, "toCtest",
  "D:\\bci\\code\\SANDBOX\\toCtest.m" };

/* Function Declarations */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "disp", true, location);
}

void toCtest(const emlrtStack *sp)
{
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 2 };

  const mxArray *m0;
  char_T cv0[2];
  int32_T i;
  static const char_T cv1[2] = { 'H', 'W' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m0 = emlrtCreateCharArray(2, iv0);
  for (i = 0; i < 2; i++) {
    cv0[i] = cv1[i];
  }

  emlrtInitCharArrayR2013a(sp, 2, m0, cv0);
  emlrtAssign(&y, m0);
  st.site = &emlrtRSI;
  disp(&st, y, &emlrtMCI);
}

/* End of code generation (toCtest.c) */
