WITH FullConnection as (SELECT *
                        FROM (SELECT conection.main          AS MainID,
                                     conection.SECOND_DOC_ID AS SecondID,
                                     dt.TITLE
                              FROM (SELECT LEVEL                            AS lev,
                                           CONNECT_BY_ROOT dr.MAIN_DOC_ID   AS main,
                                           CONNECT_BY_ROOT dr.MAIN_DOC_NAME AS mainName,
                                           dr.MAIN_DOC_ID,
                                           dr.MAIN_DOC_NAME,
                                           dr.MAIN_DOC_TYPE_ID,
                                           dr.SECOND_DOC_ID,
                                           dr.SECOND_DOC_NAME
                                    FROM orca_document_relation dr
                                    WHERE dr.DOCUMENT_RELATION_ID > 0
                                      AND dr.IS_ACTIVE = 1
                                    CONNECT BY NOCYCLE PRIOR dr.SECOND_DOC_ID = dr.MAIN_DOC_ID
                                           AND PRIOR dr.SECOND_DOC_NAME = dr.MAIN_DOC_NAME
                                    START WITH dr.MAIN_DOC_NAME = 'TradeVoucher'
                                           AND dr.MAIN_DOC_ID IN (SELECT TRADE_VOUCHER_ID
                                                                  FROM SCM_TRADE_VOUCHER
                                                                  WHERE DOCUMENT_TYPE_ID IN (2314)
                                                                    AND IS_ACTIVE = 1)) conection
                                       LEFT JOIN TRS_TREASURY_VOUCHER TREASURY_VOUCHER
                                                 ON TREASURY_VOUCHER.TREASURY_VOUCHER_ID = conection.SECOND_DOC_ID
                                       LEFT JOIN SCM_TRADE_VOUCHER TRADE_VOUCHER
                                                 ON TRADE_VOUCHER.TRADE_VOUCHER_ID = conection.SECOND_DOC_ID
                                       LEFT JOIN scm_inventory_voucher inventory_voucher
                                                 ON inventory_voucher.INVENTORY_VOUCHER_ID = conection.SECOND_DOC_ID
                                       LEFT JOIN trs_treasury_operation treasury_operation
                                                 ON treasury_operation.TREASURY_OPERATION_ID = conection.SECOND_DOC_ID
                                       LEFT JOIN fnc_accounting_voucher accounting_voucher
                                                 ON accounting_voucher.ACCOUNTING_VOUCHER_ID = conection.SECOND_DOC_ID
                                       LEFT JOIN ORCA_DOCUMENT_TYPE dt ON dt.DOCUMENT_TYPE_ID IN (
                                                                                                  TREASURY_VOUCHER.DOCUMENT_TYPE_ID,
                                                                                                  TRADE_VOUCHER.DOCUMENT_TYPE_ID,
                                                                                                  inventory_voucher.DOCUMENT_TYPE_ID,
                                                                                                  treasury_operation.DOCUMENT_TYPE_ID,
                                                                                                  accounting_voucher.DOCUMENT_TYPE_ID
                                  ))
                            PIVOT
                            ( MAX(SecondID) FOR TITLE IN (
                                'قبض پرداخت' AS ghabz,
                                'دستور پرداخت' AS dastoor,
                                'درخواست پرداخت' AS darkhastPardakht,
                                'فاکتور خرید' as factor,
                                'صورتحساب خرید خدمات و کالاهای غیر انبارشی' AS sooratkhadamat,
                                'رسید موقت' as residMovaghat,
                                'رسید خرید' as residKharid,
                                'سفارش خرید' as sefaresh,
                                'اعلامیه دریافت خدمات' as elamiekhadamat,
                                'تغییرات قرارداد خرید مرجع' as elhaghie,
                                'اعلامیه ورود کالا به انبار (مجوز رسید موقت)' as mojavezresidmovaghatElamieKala
                                )
                            ))

SELECT PurchaseContract.TRADE_VOUCHER_ID as TRADE_ID_gharardad

FROM scm_trade_voucher PurchaseContract

         inner join FullConnection on FullConnection.MainID = PurchaseContract.TRADE_VOUCHER_ID
--    left join SCM_TRADE_VOUCHER elhagie on elhagie.TRADE_VOUCHER_ID = FullConnection.ELHAGHIE
--    left join TRS_TREASURY_VOUCHER darkhastPardakht
--              on darkhastPardakht.TREASURY_VOUCHER_ID = FullConnection.DARKHASTPARDAKHT
--    left join TRS_TREASURY_VOUCHER dastoorPardakht on dastoorPardakht.TREASURY_VOUCHER_ID = FullConnection.DASTOOR
--    left join TRS_TREASURY_VOUCHER ghabz on ghabz.TREASURY_VOUCHER_ID = FullConnection.GHABZ

WHERE PurchaseContract.DOCUMENT_TYPE_ID = 2314
