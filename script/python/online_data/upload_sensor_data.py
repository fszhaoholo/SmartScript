# -*-coding:utf-8-*-
# -------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      赵福兴
#
# Created:     26/01/2019
# Copyright:   (c) 赵福兴 2019
# Licence:     <your licence>
# -------------------------------------------------------------------------------

import ssl
import json
import time
import urllib2
import requests
import urllib
import hmac
import hashlib
import base64
from requests.auth import HTTPBasicAuth
from urllib import urlencode


def post_auth():

    consumer_key = "801f7168c5ddabcd529f85184d6f6fb99b168e3af9b295d7804a9c9ae2362ea3"
    secret_key = "280278686dd061e4d54d7ef0ee0c793f4a7c86714604a287ccc4dcaeee57ef26"
    time_stamp = int(time.time())

    print time_stamp
    url = "https://hdmap.navinfo.com/auth/v1/oauth2/token"
    header = {}
    http_method = "POST"
    parameter = {"grant_type": "client_credentials"}
    header['Content-Type'] = "application/x-www-form-urlencoded"

    # do signature
    string_build = "grant_type=client_credentials&oauth_consumer_key=%s&oauth_nonce=8346887&oauth_signature_method=HMAC-SHA256&oauth_timestamp=%d&oauth_version=1.0" % (
        consumer_key, time_stamp)
    base_string = http_method.upper() + '&' + \
        urllib.quote_plus(url.lower()) + '&' + \
        urllib.quote_plus(string_build)
    print base_string

    signature = hmac.new(bytes(secret_key + '&').encode('utf-8'), bytes(base_string).encode('utf-8'),
                         digestmod=hashlib.sha256).digest()
    signature = base64.urlsafe_b64encode(signature)
    signature = urllib.quote_plus(signature)

    header['Authorization'] = '''OAuth oauth_consumer_key="%s",oauth_nonce="8346887",oauth_signature="%s",oauth_signature_method="HMAC-SHA256",oauth_timestamp="%d",oauth_version="1.0"''' % (
        consumer_key, signature, time_stamp)

    context = ssl._create_unverified_context()
    req = urllib2.Request(
        url=url, data=urllib.urlencode(parameter), headers=header)
    res_data = urllib2.urlopen(req, context=context)
    code = res_data.getcode()
    if code == 200:
        data = res_data.read()
        dirt = json.loads(data)
        auth_key = dirt['access_token']
        return auth_key
    else:
        print "request auth key error, code = %s " % (code)
        return ""


def get_datahandle(auth_key):
    authorization = auth_key
    tile_id = "557467229"
    url = "https://hdmap.navinfo.com/query/v1/catalogs/HDMap-NDS-2.5.3-Beijing-Heduo/layers/whole/partitions?version=0&partition=%s" % (
        tile_id)
    header = {}
    header['Accept'] = "application/json"
    header['Authorization'] = auth_key
    print header
    print json.dumps(header)
    print url
    req = urllib2.Request(url, headers=header)
    context = ssl._create_unverified_context()
    res_data = urllib2.urlopen(req, context=context)
    code = res_data.getcode()
    data_handle_list = []
    if code == 200:
        data = res_data.read()
        dirt = json.loads(data)
        partitions = dirt['partitions']
        for ele in partitions:
            datahandle = ele['dataHandle']
            data_handle_list.append(datahandle)
            partition = ele['partition']

        return data_handle_list
    else:
        print "request auth key error, code = %s " % (code)
        return data_handle_list


def get_data(auth_key, datahandle):
    authorization = auth_key
    # url = "https://hdmap.navinfo.com/download/v1/catalogs/HDMap-NDS-2.5.3-Beijing-Heduo/layers/whole/data/%s" % (
    #     datahandle)
    url = "https://hdmap.navinfo.com/download/v1/catalogs/HDMap-NDS-2.5.3-Beijing-Heduo/layers/whole/data/null_1d638411-0847-48f3-af9b-0551d3626212f"

    header = {}
    header['Accept'] = "application/octet-stream"
    header['Authorization'] = auth_key

    req = urllib2.Request(url=url, headers=header)
    context = ssl._create_unverified_context()
    res_data = urllib2.urlopen(req, context=context)
    code = res_data.getcode()
    print "request error code = %s " % (code)
    if code == 200:
        res = res_data.read()
        with open("tile.txt", "wb") as code:
            code.write(res)
    else:
        print "request error code = " % (code)


if __name__ == '__main__':
    # "1e5afe930980d482eefd6d756207f1227cfad3f53e7390d483244cfb58d3ab24"
    auth_key = post_auth()
    auth_key = "5ea0b6a1e8043b27e3f552adffc925cb94c44fbb5024e1f46ce14cddb16caaa3"
    get_data(auth_key, 1)
    # data_handle_list = get_datahandle(auth_key)
    # for data_handle in data_handle_list:
    #     get_data(auth_key, data_handle)
    print "a"
