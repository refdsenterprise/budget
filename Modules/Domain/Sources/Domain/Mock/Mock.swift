//
//  Mock.swift
//  
//
//  Created by Rafael Santos on 18/03/23.
//

import Foundation
import SwiftUI

public let categoriesMock = [
    CategoryEntity(
        id: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        name: "ALIMENTAÇÃO",
        color: Color(hex: "#FF2D55"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "C0070436-4FFD-4CDE-A1D8-478E9DE12B5C")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 991.8,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "312EE92E-7C27-49B8-BD81-8DB768DCAF87")!,
                date: "2023-02-01 06:34:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 1370.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "80DF5802-E16C-4AB4-B25A-5A3847B2C3E2")!,
                date: "2023-03-01 20:40:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 1212.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "171508B7-DD2F-4491-80A6-9D90B23591E3")!,
        name: "ASSINATURA",
        color: Color(hex: "#30B0C7"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "D3794CE2-5207-4A82-A450-D9F1D6DE809C")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 108.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "BE62B277-6196-46FD-A54C-48E469C88D5E")!,
                date: "2023-02-01 06:32:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 108.74,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "3722E7C4-3044-4C19-853E-EE50E3A75955")!,
                date: "2023-03-04 12:47:46".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 108.74,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "DEB8EAF5-1A05-4330-B2E5-8B2022A54415")!,
        name: "CASA",
        color: Color(hex: "#AF52DE"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "DF69C512-E9AD-4C31-955F-1D2F2AFF0394")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 413.78,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "591A6707-25F6-4126-B696-9741E5098D7D")!,
                date: "2023-02-01 06:30:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 416.03,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "6E07898D-5E0C-4400-B42A-44DA50AF5806")!,
                date: "2023-03-01 20:39:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 403.84,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "45A319E9-4578-4EF5-91E1-8D3D5D1C5C1D")!,
        name: "EDUCAÇÃO",
        color: Color(hex: "#FF9500"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "3FD3297B-4290-422C-9381-8C5DFDA49572")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 258.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "8FD91BD8-342A-4203-AB3D-87D7B2E20C1E")!,
                date: "2023-02-01 06:35:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 258.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "20C60818-5E3D-442B-8ECE-08D26D370785")!,
        name: "IMPREVISTO",
        color: Color(hex: "#FFCC00"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "69DDF0C9-E406-4DA2-84D3-1108C851FD82")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 600.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "21E0FEE8-ADF6-4054-8041-3F8ABDB06278")!,
                date: "2023-02-01 15:05:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 80.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "AA114908-9FF0-4ECD-B5FE-C5F85C911F9F")!,
                date: "2023-03-04 12:47:46".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 80.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "963B961D-05F2-4175-BCBE-AB4FF4124B49")!,
        name: "LAZER",
        color: Color(hex: "#B51A00"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "A5084617-E4BC-4F38-A48D-57CCBC27FA64")!,
                date: "2023-02-02 06:40:25".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 80.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "FEC36787-7098-4DB4-BF04-5B8E4AF1275E")!,
                date: "2023-03-01 20:41:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 100.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "5C9646ED-1A01-45E6-B608-71979A9E5B09")!,
        name: "SAÚDE",
        color: Color(hex: "#5856D6"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "9B817E93-E26B-4A98-8F7D-660CB166BFE4")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 120.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "368A23F5-1421-4EA7-AECF-59552AE81FA5")!,
                date: "2023-02-01 06:37:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 175.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "59D6F510-3798-4EB5-A7DE-FF2541226147")!,
                date: "2023-03-01 20:43:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 554.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        name: "TRANSPORTE",
        color: Color(hex: "#34C759"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "DF5BE9AF-F0E8-4B95-8B4C-B7AC8A80F1BF")!,
                date: "2023-01-01 04:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 612.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "A1FFDE8F-312D-4B73-A02D-145AFDA0F3B6")!,
                date: "2023-02-01 06:39:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 628.0,
                description: nil
            ),
            BudgetEntity(
                id: UUID(uuidString: "2EAB4424-745F-4917-A3E4-537574356F94")!,
                date: "Date 2023-03-01 20:45:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 455.0,
                description: nil
            )
        ]
    ),
    CategoryEntity(
        id: UUID(uuidString: "0668FAE3-B03B-45F9-96CF-1E9DE22D815B")!,
        name: "VIAGEM",
        color: Color(hex: "#FF7900"),
        budgets: [
            BudgetEntity(
                id: UUID(uuidString: "12871F0F-A55E-469B-8AD8-7D2EA3164841")!,
                date: "2023-03-27 04:44:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
                amount: 1240.0,
                description: Optional("Confraternização do cartola no Rio de Janeiro"))
        ]
    )
]

public let transactionsMock: [TransactionEntity] = [
    TransactionEntity(
        id: UUID(uuidString: "28290F3C-9FD7-496A-9242-F766C48C3C2E")!,
        date: "2023-03-18 18:56:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber de casa para casa do beltrano e depois para pao e tal",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.66),
    TransactionEntity(
        id: UUID(uuidString: "A1D02B59-33F5-4D3F-ACD2-8EE3B0F914CE")!,
        date: "2023-03-18 03:11:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sushi com o fulano e o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 80.19),
    TransactionEntity(
        id: UUID(uuidString: "DC1D0602-FD13-42ED-8986-1D61287F790B")!,
        date: "2023-03-17 22:52:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do shopping para smartfit com o beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 5.33),
    TransactionEntity(
        id: UUID(uuidString: "5549B592-8D21-4565-8460-7628793BD432")!,
        date: "2023-03-17 22:37:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Jantar no madero com a sicrano e o beltrano pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 145.93
    ),
    TransactionEntity(
        id: UUID(uuidString: "70D09A07-E710-4853-A46E-D0301DB8F566")!,
        date: "2023-03-17 21:28:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café na kopenhagem com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 17.15
    ),
    TransactionEntity(
        id: UUID(uuidString: "DEE259D7-3EF4-4F45-B14A-2234DBBEDE89")!,
        date: "2023-03-17 19:53:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minha casa para casa do beltrano e depois para o shopping ",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 5.19
    ),
    TransactionEntity(
        id: UUID(uuidString: "0622B773-C3C2-4F5A-B7B2-70AF70B11A34")!,
        date: "2023-03-17 15:13:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Coca e bolacha no açougue ",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 10.96
    ),
    TransactionEntity(
        id: UUID(uuidString: "383649ED-1839-4360-93B8-F63212893049")!,
        date: "2023-03-17 01:43:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da sesamo para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 7.72
    ),
    TransactionEntity(
        id: UUID(uuidString: "1B15C2C0-1F4A-4627-ADC3-05552512375B")!,
        date: "2023-03-17 01:09:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sorvete na sesamo com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 15.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "1ECA8870-846D-4123-9B16-7201939F173A")!,
        date: "2023-03-17 01:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Hot Filadélfia no riory com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 27.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "30478544-B098-4541-B487-4F4F4E062228")!,
        date: "2023-03-16 22:18:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Pão e tal com o beltrano pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 4.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "B1345CFF-2E64-45FD-87D6-076D38FB9B37")!,
        date: "2023-03-16 21:19:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber para pão e tal",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 8.5
    ),
    TransactionEntity(
        id: UUID(uuidString: "6AACFB99-0961-4150-99FA-14BDAC772FA6")!,
        date: "2023-03-16 02:46:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do massa sushi para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 5.87
    ),
    TransactionEntity(
        id: UUID(uuidString: "BA6E1030-C294-494C-883D-8AC2C17360E1")!,
        date: "2023-03-15 23:20:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Pão e tal com o beltrano pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 10.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "9C108A1C-F1BC-4CAE-A220-FC1756C891E0")!,
        date: "2023-03-15 20:41:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café especiaria na sésamo com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 10.5
    ),
    TransactionEntity(
        id: UUID(uuidString: "8E8C8EC1-1AFF-44C8-85FE-64839480CBF0")!,
        date: "2023-03-15 20:14:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minha casa para casa do beltrano para sesamo",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.25
    ),
    TransactionEntity(
        id: UUID(uuidString: "118FA759-0F2E-40B4-ABA6-DCA82E5EA916")!,
        date: "2023-03-15 07:45:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Proxyman premium",
        categoryUUID: UUID(uuidString: "20C60818-5E3D-442B-8ECE-08D26D370785")!,
        amount: 16.9
    ),
    TransactionEntity(
        id: UUID(uuidString: "6EED353C-A02D-44F2-90B9-D3527AF82245")!,
        date: "2023-03-14 23:21:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca e pão com mel na pao e tal com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 10.7
    ),
    TransactionEntity(
        id: UUID(uuidString: "67474F8D-6F25-45D7-B817-B65FE3F1D82E")!,
        date: "2023-03-14 02:04:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da sesamo para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 8.23
    ),
    TransactionEntity(
        id: UUID(uuidString: "2754C033-61C5-4C55-A180-99105E78997A")!,
        date: "2023-03-14 01:27:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café especiarias e sorvete na sesamo com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 25.5
    ),
    TransactionEntity(
        id: UUID(uuidString: "76EFCFB1-61EA-4C29-8535-32F9036FC32C")!,
        date: "2023-03-13 22:13:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minha casa para doce momentos",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 10.71
    ),
    TransactionEntity(
        id: UUID(uuidString: "A2FAB543-4505-48F5-97DD-7D25A87929DA")!,
        date: "2023-03-13 15:55:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Churrasco do cartola",
        categoryUUID: UUID(uuidString: "0668FAE3-B03B-45F9-96CF-1E9DE22D815B")!,
        amount: 110.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "00ADF01D-CAA0-4A20-9ED9-454D0833670C")!,
        date: "2023-03-13 04:18:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minha casa para casa da fulano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 18.55
    ),
    TransactionEntity(
        id: UUID(uuidString: "B7F3ABB5-B470-4921-9838-F0A8D02625CE")!,
        date: "2023-03-13 00:54:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do shopping para minha casa com a fulano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 21.11
    ),
    TransactionEntity(
        id: UUID(uuidString: "FAD404CB-B255-45EF-A3DE-5384F3E57CED")!,
        date: "2023-03-13 00:26:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Jantar no outback com a fulano pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 117.7
    ),
    TransactionEntity(
        id: UUID(uuidString: "50E11845-392D-4F52-A4CF-934080969603")!,
        date: "2023-03-12 22:27:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da sesamo para shopping com o beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 7.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "03CD2C13-8B4A-4663-B89D-4564D87EB8AC")!,
        date: "2023-03-12 21:50:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sesamo com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 15.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "3B45A127-B910-4F5F-BF40-3ADD417D24AA")!,
        date: "2023-03-12 20:43:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café coado na pão e tal com o beltrano pago com sodex",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 9.8
    ),
    TransactionEntity(
        id: UUID(uuidString: "4E19BED9-DF8C-4A4A-84E0-13B123AE5DDA")!,
        date: "2023-03-12 19:43:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minhacasa para casa do beltrano e depois para sesamo",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 4.43
    ),
    TransactionEntity(
        id: UUID(uuidString: "C0DC2F81-97FB-4278-AF2D-F9C9FE8A9020")!,
        date: "2023-03-11 15:01:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da doce momentos para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 5.98
    ),
    TransactionEntity(
        id: UUID(uuidString: "36DEA924-4C73-4AD2-8219-ADE09A1144B9")!,
        date: "2023-03-11 14:53:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca com beltrano e bem casado para sicrano na doce momentos pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 9.27
    ),
    TransactionEntity(
        id: UUID(uuidString: "E99545B5-5496-4FE1-9269-873B3E21CB96")!,
        date: "2023-03-11 14:05:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Conta de celular da vivo",
        categoryUUID: UUID(uuidString: "DEB8EAF5-1A05-4330-B2E5-8B2022A54415")!,
        amount: 56.73
    ),
    TransactionEntity(
        id: UUID(uuidString: "007696E7-3EEC-4D92-8D41-BB4E255872A4")!,
        date: "2023-03-11 13:34:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca e pão na chapa com o beltrano na pão e tal",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 8.9
    ),
    TransactionEntity(
        id: UUID(uuidString: "41DDB17C-7DEC-40F7-A780-9234FB366DB7")!,
        date: "2023-03-11 05:06:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber para levar a fulano em casa",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 23.6
    ),
    TransactionEntity(
        id: UUID(uuidString: "C2313447-754E-4021-AFE4-97F938CC44EC")!,
        date: "2023-03-11 04:12:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Cuidados pessoais na drogasil ",
        categoryUUID: UUID(uuidString: "5C9646ED-1A01-45E6-B608-71979A9E5B09")!,
        amount: 23.09
    ),
    TransactionEntity(
        id: UUID(uuidString: "E4E52286-8701-4EE7-BEC0-C8FA33463CDC")!,
        date: "2023-03-11 02:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da sesamo para minha casa com a fulano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 8.31
    ),
    TransactionEntity(
        id: UUID(uuidString: "629CB5E6-5327-46B2-83B4-3EAB7A763F0D")!,
        date: "2023-03-11 01:33:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sesamo com a fulano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 30.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "65E5834C-9B03-4E34-86CA-D257B38150E4")!,
        date: "2023-03-11 01:12:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sushi no ryori com a fulano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 159.4
    ),
    TransactionEntity(
        id: UUID(uuidString: "DE0E0AD4-8E8A-4F23-BC65-9D0BC2523672")!,
        date: "2023-03-10 23:00:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café especiarias e café carioca na sesamo com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 17.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "70B3B9B5-753B-4D89-97EF-C1D5908A3A0B")!,
        date: "2023-03-10 20:10:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber para casa do beltrano depois para sésamo",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.29
    ),
    TransactionEntity(
        id: UUID(uuidString: "74F3DAA8-2BD5-4446-800C-23D14AE9936A")!,
        date: "2023-03-10 13:44:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Remédio para alergia",
        categoryUUID: UUID(uuidString: "20C60818-5E3D-442B-8ECE-08D26D370785")!,
        amount: 50.44
    ),
    TransactionEntity(
        id: UUID(uuidString: "C08EAF5D-B4C1-4277-A4F5-16EF14EA8AC5")!,
        date: "2023-03-10 02:31:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do massa para casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.86
    ),
    TransactionEntity(
        id: UUID(uuidString: "85FA5BB6-2837-4A40-8869-543AAA2403A4")!,
        date: "2023-03-10 02:21:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sushi com o beltrano no massa",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 28.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "831085A9-245E-4481-8B20-606DA5782FAB")!,
        date: "2023-03-09 22:49:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café com a fulano na doce momentos pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 18.5
    ),
    TransactionEntity(
        id: UUID(uuidString: "3DA05C1A-BE51-4DDE-B052-D42B7D9291E9")!,
        date: "2023-03-09 20:31:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber de casa para doce momentos com a fulano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 4.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "1F7D0945-C712-40E5-A97C-0355F5737292")!,
        date: "2023-03-09 02:54:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do sushi para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 7.69
    ),
    TransactionEntity(
        id: UUID(uuidString: "472B243D-6C10-4B1F-B82E-192F1E20879C")!,
        date: "2023-03-09 02:53:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sushi no massa com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 26.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "5D1507A2-AA46-4A8D-AE2D-E5118E3993EB")!,
        date: "2023-03-09 00:33:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca na pão e tal com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 4.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "B139A212-316F-4F1E-84DF-B8681023BA50")!,
        date: "2023-03-08 05:54:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Assinatura apple one pessoal",
        categoryUUID: UUID(uuidString: "171508B7-DD2F-4491-80A6-9D90B23591E3")!,
        amount: 34.9
    ),
    TransactionEntity(
        id: UUID(uuidString: "059EFCE1-72D2-4B50-9FCE-8E31FA23D231")!,
        date: "2023-03-08 05:54:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "iCloud 2TB",
        categoryUUID: UUID(uuidString: "171508B7-DD2F-4491-80A6-9D90B23591E3")!,
        amount: 34.9
    ),
    TransactionEntity(
        id: UUID(uuidString: "DEAF10AD-85D1-42FC-8A0C-A4CD4151C00F")!,
        date: "2023-03-07 02:49:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do massa para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.89
    ),
    TransactionEntity(
        id: UUID(uuidString: "F892F6B1-6B37-4D53-BBD1-6F949C16FFF7")!,
        date: "2023-03-07 02:35:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Sushi no massa com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 28.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "72F1FCA1-AAB1-49D2-8EAC-57DDC08A1FD1")!,
        date: "2023-03-06 23:26:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Calera para academia",
        categoryUUID: UUID(uuidString: "5C9646ED-1A01-45E6-B608-71979A9E5B09")!,
        amount: 19.9
    ),
    TransactionEntity(
        id: UUID(uuidString: "282B911A-644B-4A9F-B3EE-764D383259E8")!,
        date: "2023-03-06 23:11:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca e bubbalo na pão e tal com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 4.8
    ),
    TransactionEntity(
        id: UUID(uuidString: "E1A49199-3E48-4B24-A254-16CB4CFEF332")!,
        date: "2023-03-06 04:31:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber para a fulano ir para casa",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 16.38
    ),
    TransactionEntity(
        id: UUID(uuidString: "0388E70F-FBE3-40BD-9865-D6B2A51E7AE7")!,
        date: "2023-03-06 01:06:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do jardim central para minha casa com a fulano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 9.64
    ),
    TransactionEntity(
        id: UUID(uuidString: "E0EE6DB5-1453-46C0-A343-ED66DF78DF31")!,
        date: "2023-03-06 00:23:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Jantar com a fulano no jardim central pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 101.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "C29D8F53-0624-4616-A22B-4A5884183B57")!,
        date: "2023-03-05 21:30:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Misto light e cappuccino com a fulano na pão e tal pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 35.1
    ),
    TransactionEntity(
        id: UUID(uuidString: "D83096C0-F8FE-4494-BEE6-85B5AA20FEF7")!,
        date: "2023-03-05 04:17:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber do shopping para casa da fulano depois para minha",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 41.01
    ),
    TransactionEntity(
        id: UUID(uuidString: "ABE38DD7-13A1-4D14-87F9-A43D5CB407C2")!,
        date: "2023-03-05 01:30:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Jantar no ítalo pasta com a fulano pago com sodexo",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 105.6
    ),
    TransactionEntity(
        id: UUID(uuidString: "502778D6-776E-4A0D-A9BE-BE5E80503979")!,
        date: "2023-03-04 22:30:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Ingresso do filme a baleia com a fulano",
        categoryUUID: UUID(uuidString: "963B961D-05F2-4175-BCBE-AB4FF4124B49")!,
        amount: 40.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "5F6EA56A-BDD3-481C-995F-3D49608C8D5A")!,
        date: "2023-03-04 22:05:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da sesamo para casa e depois para o shopping",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 13.37
    ),
    TransactionEntity(
        id: UUID(uuidString: "1165D636-3F19-428C-A404-CBBEEBAAF097")!,
        date: "2023-03-04 19:30:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da minha casa para casa do beltrano e depois para a sesamo",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.77
    ),
    TransactionEntity(
        id: UUID(uuidString: "102E638A-387E-465E-B851-96E7BDB36B5F")!,
        date: "2023-03-04 14:46:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber da smart fit para minha casa e depois para casa do beltrano",
        categoryUUID: UUID(uuidString: "30A9AF6A-033A-4296-A7F6-CD393AABCD77")!,
        amount: 6.39
    ),
    TransactionEntity(
        id: UUID(uuidString: "5867C87C-EE45-4456-B29B-2B5B73D189B5")!,
        date: "2023-03-04 14:45:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Almoço no serra com a sicrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 19.95
    ),
    TransactionEntity(
        id: UUID(uuidString: "DA13980C-AE25-477F-9CAC-5E979EFAE0B2")!,
        date: "2023-03-04 13:15:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca na pão e tal com beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 4.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "E999EC32-435A-46C8-B784-A905F1CA0FF7")!,
        date: "2023-03-04 00:31:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Café carioca na pao e tal com o beltrano",
        categoryUUID: UUID(uuidString: "D9C1034A-8099-4A3D-89C8-A487177F51B4")!,
        amount: 4.2
    ),
    TransactionEntity(
        id: UUID(uuidString: "23B0D12B-92B6-4BAC-9260-9F254C9E130F")!,
        date: "2023-03-03 22:16:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "HBO Max",
        categoryUUID: UUID(uuidString: "171508B7-DD2F-4491-80A6-9D90B23591E3")!,
        amount: 13.95
    ),
    TransactionEntity(
        id: UUID(uuidString: "F38500AE-791B-4CC0-9D4E-0EBC2E54A688")!,
        date: "2023-03-03 16:51:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Whey protein, creatina e coqueteleira",
        categoryUUID: UUID(uuidString: "5C9646ED-1A01-45E6-B608-71979A9E5B09")!,
        amount: 310.0
    ),
    TransactionEntity(
        id: UUID(uuidString: "4F8B0CA6-5A1C-4A8E-A37D-4235636D88C9")!,
        date: "2023-03-02 00:55:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Uber pass",
        categoryUUID: UUID(uuidString: "171508B7-DD2F-4491-80A6-9D90B23591E3")!,
        amount: 24.99),
    TransactionEntity(
        id: UUID(uuidString: "AFD0832D-8416-46E2-B4B9-B84CF64A69C2")!,
        date: "2023-03-01 18:33:00".asDate(withFormat: .custom("yyyy-MM-dd HH:mm:ss")),
        description: "Mensalidade smart fit plano smart",
        categoryUUID: UUID(uuidString: "5C9646ED-1A01-45E6-B608-71979A9E5B09")!,
        amount: 119.9)]

