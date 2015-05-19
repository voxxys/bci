/*
 * _coder_toCtest_info.c
 *
 * Code generation for function 'toCtest'
 *
 */

/* Include files */
#include "_coder_toCtest_info.h"

/* Function Declarations */
static void info_helper(const mxArray **info);
static const mxArray *emlrt_marshallOut(const char * u);
static const mxArray *b_emlrt_marshallOut(const uint32_T u);

/* Function Definitions */
const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  nameCaptureInfo = NULL;
  emlrtAssign(&nameCaptureInfo, emlrtCreateStructMatrix(3, 1, 0, NULL));
  info_helper(&nameCaptureInfo);
  emlrtNameCapturePostProcessR2013b(&nameCaptureInfo);
  return nameCaptureInfo;
}

static void info_helper(const mxArray **info)
{
  const mxArray *rhs0 = NULL;
  const mxArray *lhs0 = NULL;
  const mxArray *rhs1 = NULL;
  const mxArray *lhs1 = NULL;
  const mxArray *rhs2 = NULL;
  const mxArray *lhs2 = NULL;
  emlrtAddField(*info, emlrt_marshallOut("[E]D:/bci/code/SANDBOX/toCtest.m"),
                "context", 0);
  emlrtAddField(*info, emlrt_marshallOut("disp"), "name", 0);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 0);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXMB]$matlabroot$/toolbox/matlab/lang/disp"), "resolved", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "fileTimeLo", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "fileTimeHi", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "mFileTimeLo", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "mFileTimeHi", 0);
  emlrtAssign(&rhs0, emlrtCreateCellMatrix(0, 1));
  emlrtAssign(&lhs0, emlrtCreateCellMatrix(0, 1));
  emlrtAddField(*info, emlrtAliasP(rhs0), "rhs", 0);
  emlrtAddField(*info, emlrtAliasP(lhs0), "lhs", 0);
  emlrtAddField(*info, emlrt_marshallOut(""), "context", 1);
  emlrtAddField(*info, emlrt_marshallOut(""), "name", 1);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 1);
  emlrtAddField(*info, emlrt_marshallOut("[U]D:/bci/code/SANDBOX/states.mat"),
                "resolved", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(1432000683U), "fileTimeLo", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 1);
  emlrtAssign(&rhs1, emlrtCreateCellMatrix(0, 1));
  emlrtAssign(&lhs1, emlrtCreateCellMatrix(0, 1));
  emlrtAddField(*info, emlrtAliasP(rhs1), "rhs", 1);
  emlrtAddField(*info, emlrtAliasP(lhs1), "lhs", 1);
  emlrtAddField(*info, emlrt_marshallOut("[E]D:/bci/code/SANDBOX/toCtest.m"),
                "context", 2);
  emlrtAddField(*info, emlrt_marshallOut("disp"), "name", 2);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 2);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXMB]$matlabroot$/toolbox/matlab/lang/disp"), "resolved", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "fileTimeLo", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "fileTimeHi", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "mFileTimeLo", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(MAX_uint32_T), "mFileTimeHi", 2);
  emlrtAssign(&rhs2, emlrtCreateCellMatrix(0, 1));
  emlrtAssign(&lhs2, emlrtCreateCellMatrix(0, 1));
  emlrtAddField(*info, emlrtAliasP(rhs2), "rhs", 2);
  emlrtAddField(*info, emlrtAliasP(lhs2), "lhs", 2);
  emlrtDestroyArray(&rhs0);
  emlrtDestroyArray(&lhs0);
  emlrtDestroyArray(&rhs1);
  emlrtDestroyArray(&lhs1);
  emlrtDestroyArray(&rhs2);
  emlrtDestroyArray(&lhs2);
}

static const mxArray *emlrt_marshallOut(const char * u)
{
  const mxArray *y;
  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateString(u);
  emlrtAssign(&y, m0);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const uint32_T u)
{
  const mxArray *y;
  const mxArray *m1;
  y = NULL;
  m1 = emlrtCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
  *(uint32_T *)mxGetData(m1) = u;
  emlrtAssign(&y, m1);
  return y;
}

MEXFUNCTION_LINKAGE mxArray *emlrtMexFcnProperties(void);
mxArray *emlrtMexFcnProperties()
{
  const char *mexProperties[] = {
    "Version",
    "ResolvedFunctions",
    "EntryPoints",
    "CoverageInfo",
    NULL };

  const char *epProperties[] = {
    "Name",
    "NumberOfInputs",
    "NumberOfOutputs",
    "ConstantInputs" };

  mxArray *xResult = mxCreateStructMatrix(1,1,4,mexProperties);
  mxArray *xEntryPoints = mxCreateStructMatrix(1,1,4,epProperties);
  mxArray *xInputs = NULL;
  xInputs = mxCreateLogicalMatrix(1, 0);
  mxSetFieldByNumber(xEntryPoints, 0, 0, mxCreateString("toCtest"));
  mxSetFieldByNumber(xEntryPoints, 0, 1, mxCreateDoubleScalar(0));
  mxSetFieldByNumber(xEntryPoints, 0, 2, mxCreateDoubleScalar(0));
  mxSetFieldByNumber(xEntryPoints, 0, 3, xInputs);
  mxSetFieldByNumber(xResult, 0, 0, mxCreateString("8.3.0.532 (R2014a)"));
  mxSetFieldByNumber(xResult, 0, 1, (mxArray*)emlrtMexFcnResolvedFunctionsInfo());
  mxSetFieldByNumber(xResult, 0, 2, xEntryPoints);
  return xResult;
}

/* End of code generation (_coder_toCtest_info.c) */
