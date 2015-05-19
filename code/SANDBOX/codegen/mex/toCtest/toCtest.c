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

static emlrtMCInfo b_emlrtMCI = { 8, 1, "toCtest",
  "D:\\bci\\code\\SANDBOX\\toCtest.m" };

static emlrtRSInfo emlrtRSI = { 8, "toCtest",
  "D:\\bci\\code\\SANDBOX\\toCtest.m" };

static emlrtRSInfo b_emlrtRSI = { 3, "toCtest",
  "D:\\bci\\code\\SANDBOX\\toCtest.m" };

/* Function Declarations */
static const mxArray *b_emlrt_marshallOut(const real_T u);
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const char_T u[2]);

/* Function Definitions */
static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m1;
  y = NULL;
  m1 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m1);
  return y;
}

static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "disp", true, location);
}

static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const char_T u[2])
{
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 2 };

  const mxArray *m0;
  char_T b_u[2];
  int32_T i0;
  y = NULL;
  m0 = emlrtCreateCharArray(2, iv0);
  for (i0 = 0; i0 < 2; i0++) {
    b_u[i0] = u[i0];
  }

  emlrtInitCharArrayR2013a(sp, 2, m0, b_u);
  emlrtAssign(&y, m0);
  return y;
}

void toCtest(const emlrtStack *sp)
{
  static const char_T cv0[2] = { 'H', 'W' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &b_emlrtRSI;
  disp(&st, emlrt_marshallOut(&st, cv0), &emlrtMCI);

  /*  QQs = coder.load('D:/bci/code/SANDBOX/QQs.mat'); */
  st.site = &emlrtRSI;
  disp(&st, b_emlrt_marshallOut(6.0), &b_emlrtMCI);
}

/* End of code generation (toCtest.c) */
