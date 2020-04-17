//
//  JXHttpRequestDef.h
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#ifndef JXHttpRequestDef_h
#define JXHttpRequestDef_h


//
//请求url定义
//

//获取注册验证码
#define RequestUrl_RegisterSMSCode  @"/api/register/getsmscode"
#define RequestUrl_RegisterByPhone  @"/api/register/phoneregister"
#define RequestUrl_PefectDatum      @"/api/register/perfectdatum"

#define RequestUrl_PasswordLogin    @"/api/login/passwordlogin"
#define RequestUrl_GetLoginSMSCode  @"/api/login/getsmscode"
#define RequestUrl_SMSLogin         @"/api/login/smslogin"
#define RequestUrl_AutoLogin        @"/api/login/autologin"

#define RequestUrl_SearchAccount    @"/api/accountmanage/searchaccount";

#define RequestUrl_UploadHeaderToken @"/api/accountmanage/requestuploadheadertoken"
#define RequestUrl_ModifyHeader     @"/api/accountmanage/modifyheader"
#define RequestUrl_ModifyNickname     @"/api/accountmanage/modifynickname"
#define RequestUrl_ModifyGender     @"/api/accountmanage/modifygender"

#define RequestUrl_GetSMSCode       @"/api/smscode/getsmscode"
#define RequestUrl_SetInitLoginPwd  @"/api/accountmanage/setinitloginpwd"
#define RequestUrl_ResetLoginPwd    @"/api/accountmanage/resetloginpwd"
#define RequestUrl_ModifyLoginPwd   @"/api/accountmanage/modifyloginpwd"
#define RequestUrl_ModifyPhone      @"/api/accountmanage/modifyphone"

#endif /* JXHttpRequestDef_h */
