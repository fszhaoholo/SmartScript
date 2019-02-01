
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


def post_auth(uri, consumer_key, secret_key):
    time_stamp = int(time.time())
    print time_stamp

    url = "%s/auth/v1/oauth2/token" % (uri)
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
        # Bearer + space + auth_key
        return "Bearer %s" % (auth_key)
    else:
        print "request auth key error, code = %s " % (code)
        return ""


def get_datahandle(uri, auth_key):
    authorization = auth_key
    tile_id = "557467229"
    url = "%s/query/v1/catalogs/HDMap-NDS-2.5.3-Beijing-Heduo/layers/whole/partitions?version=0&partition=%s" % (
        uri, tile_id)
    header = {}
    header['Accept'] = "application/json"
    header['Authorization'] = auth_key
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


def get_data(uri, auth_key, datahandle):
    url = "%s/download/v1/catalogs/HDMap-NDS-2.5.3-Beijing-Heduo/layers/whole/data/%s" % (
        uri, datahandle)

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


def upload_sensor_data(uri, auth_key):
    url = "%s/ingest/v1/catalogs/Sensordata-JSON-2.0-Beijing-Heduo/layers/sensordata" % (
        uri)

    header = {}
    header['Accept'] = "application/octet-stream"
    header['Content-Type'] = "application/x-protobuf"
    header['Authorization'] = auth_key

    # need make real sensor data
    file = open('tile.txt', 'r')
    binary = file.read()
    file.close()
    ret = requests.post(url, data=json.dumps(binary),
                        headers=header)
    response_code = ret.status_code
    response = ret.text
    print response_code
    print response


if __name__ == '__main__':
    uri = "https://hdmap.navinfo.com"
    consumer_key = "801f7168c5ddabcd529f85184d6f6fb99b168e3af9b295d7804a9c9ae2362ea3"
    secret_key = "280278686dd061e4d54d7ef0ee0c793f4a7c86714604a287ccc4dcaeee57ef26"

    auth_key = post_auth(uri)
    # auth_key = "51d427448b88146b83dbeed3df40f63158348e946a1d66160775261232c535de"
    data_handle_list = get_datahandle(uri, auth_key)
    for data_handle in data_handle_list:
        get_data(uri, auth_key, data_handle)
    upload_sensor_data(uri, auth_key)
    print "HHHHHHHHHHHHHHHHHH"
