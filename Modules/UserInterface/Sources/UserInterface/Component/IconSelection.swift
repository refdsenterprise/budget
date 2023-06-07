//
//  IconSelection.swift
//  
//
//  Created by Rafael Santos on 06/06/23.
//

import SwiftUI
import RefdsUI

public struct IconSelection: View {
    @Binding private var icon: RefdsIconSymbol
    private var icons: [RefdsIconSymbol] = [.dollarsign, .pencilLine, .scribbleVariable, .pencilTip, .pencilTipCropCircle, .trashFill, .paperplaneFill, .trayFullFill, .tray2Fill, .externaldriveFill, .internaldriveFill, .archiveboxFill, .docFill, .docTextFill, .docOnClipboard, .listBulletClipboardFill, .listClipboardFill, .docRichtextFill, .docAppendFill, .docTextBelowEcgFill, .chartBarDocHorizontalFill, .terminalFill, .booksVerticalFill, .bookClosedFill, .characterBookClosedFill, .textBookClosedFill, .magazineFill, .newspaperFill, .docTextImageFill, .bookmarkFill, .graduationcapFill, .pencilAndRulerFill, .rulerFill, .backpackFill, .studentdesk, .paperclip, .personFill, .person2Fill, .person3Fill, .personCropCircleFill, .personCropArtframe, .photoArtframe, .personCropSquareFilledAndAtRectangleFill, .squareAndAtRectangleFill, .personTextRectangleFill, .figureStand, .figureArmsOpen, .figure2AndChildHoldinghands, .figureWalk, .figureWalkMotion, .figureWave, .figureRun, .figureAmericanFootball, .figureArchery, .figureAustralianFootball, .figureBadminton, .figureBarre, .figureBaseball, .figureBasketball, .figureBowling, .figureBoxing, .figureClimbing, .figureCooldown, .figureCoreTraining, .figureCricket, .figureSkiingCrosscountry, .figureCrossTraining, .figureCurling, .figureDance, .figureDiscSports, .figureSkiingDownhill, .figureElliptical, .figureEquestrianSports, .figureFencing, .figureFishing, .figureFlexibility, .figureStrengthtrainingFunctional, .figureGolf, .figureGymnastics, .figureHandCycling, .figureHandball, .figureHighintensityIntervaltraining, .figureHiking, .figureHockey, .figureHunting, .figureIndoorCycle, .figureJumprope, .figureKickboxing, .figureLacrosse, .figureMartialArts, .figureMindAndBody, .figureMixedCardio, .figureOpenWaterSwim, .figureOutdoorCycle, .oar2Crossed, .figurePickleball, .figurePilates, .figurePlay, .figurePoolSwim, .figureRacquetball, .figureRolling, .figureRower, .figureRugby, .figureSailing, .figureSkating, .figureSnowboarding, .figureSoccer, .figureSocialdance, .figureSoftball, .figureSquash, .figureStairStepper, .figureStairs, .figureStepTraining, .figureSurfing, .figureTableTennis, .figureTaichi, .figureTennis, .figureTrackAndField, .figureStrengthtrainingTraditional, .figureVolleyball, .figureWaterFitness, .figureWaterpolo, .figureWrestling, .figureYoga, .dumbbell, .dumbbellFill, .sportscourtFill, .soccerball, .baseballFill, .basketballFill, .footballFill, .tennisRacket, .tennisballFill, .volleyballFill, .trophyFill, .medalFill, .globeAmericasFill, .sunMaxFill, .moonFill, .cloudRainFill, .cloudFogFill, .cloudSnowFill, .cloudBoltRainFill, .snowflake, .thermometerMedium, .flameFill, .beachUmbrellaFill, .speakerWave2Fill, .musicNote, .musicMic, .micFill, .flagAndFlagFilledCrossed, .bellAndWavesLeftAndRightFill, .tagFill, .boltFill, .flashlightOnFill, .cameraFill, .phoneFill, .videoFill, .envelope, .bagFill, .cartFill, .basketFill, .creditcardFill, .giftcardFill, .walletPassFill, .pianokeysInverse, .paintbrushFill, .paintbrushPointedFill, .hammerFill, .wrenchAndScrewdriverFill, .stethoscope, .crossCaseFill, .theatermasksFill, .theatermaskAndPaintbrushFill, .puzzlepieceFill, .houseFill, .lightbulbFill, .lightbulb2Fill, .lightbulbLedWideFill, .fanbladesFill, .fanDeskFill, .fanCeilingFill, .fanAndLightCeilingFill, .lampDeskFill, .lampTableFill, .lampFloorFill, .lampCeilingFill, .lampCeilingInverse, .lightCylindricalCeilingInverse, .lightBeaconMaxFill, .entryLeverKeypadFill, .blindsVerticalClosed, .showerFill, .balloon2Fill, .fryingPanFill, .popcornFill, .bedDoubleFill, .sofaFill, .fireplaceFill, .washerFill, .cooktopFill, .tentFill, .houseLodgeFill, .mountain2Fill, .building2Fill, .lockFill, .keyHorizontalFill, .wifi, .mapFill, .powerplugFill, .airtagFill, .display, .macproGen1Fill, .macproGen2Fill, .macproGen3Fill, .laptopcomputer, .ipod, .iphoneGen3, .ipadGen2Landscape, .magicmouseFill, .applewatch, .applewatchSideRight, .airpodsmax, .earbuds, .airpodspro, .airpodsGen3, .homepodminiFill, .hifispeakerAndHomepodminiFill, .hifispeakerFill, .hifispeaker2Fill, .cableConnector, .tv, .tvFill, .guitarsFill, .airplane, .carFill, .car2Fill, .busFill, .busDoubledecker, .tramFill, .cablecarFill, .ferryFill, .boxTruckFill, .bicycle, .scooter, .strollerFill, .sailboatFill, .fuelpumpFill, .carSideFill, .pills, .crossFill, .ivfluidBagFill, .heartTextSquareFill, .hareFill, .tortoiseFill, .lizardFill, .birdFill, .ladybugFill, .fishFill, .pawprintFill, .teddybearFill, .leafFill, .treeFill, .tshirtFill, .filmFill, .ticketFill, .combFill, .mustacheFill, .brainHeadProfile, .brain, .handRaisedFingersSpreadFill, .crownFill, .gamecontrollerFill, .swatchpaletteFill, .cupAndSaucerFill, .wineglassFill, .birthdayCakeFill, .forkKnife, .cellularbars, .chartPieFill, .chartBarXaxis, .simcard2Fill, .giftFill, .appGiftFill, .hourglassTophalfFilled, .lifepreserver, .binocularsFill, .appleLogo]
    private var axes: Axis.Set
    private let color: RefdsColor
    
    public init(icon: Binding<RefdsIconSymbol>, color: RefdsColor, axes: Axis.Set = .horizontal) {
        self._icon = icon
        self.color = color
        self.axes = axes
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(icons, id: \.rawValue) { icon in
                    RefdsButton {
                        self.icon = icon
                    } label: {
                        RefdsIcon(symbol: icon, color: self.icon == icon ? color : .primary, size: 20, renderingMode: .hierarchical)
                            .frame(width: 25, height: 25)
                            .padding(.all, 5)
                            .background(self.icon == icon ? color.opacity(0.2) : .clear)
                            .cornerRadius(8)
                    }
                }
            }
            .frame(minHeight: 50)
            .padding(.horizontal)
        }
    }
}

struct IconSelectionView: View {
    @State private var icon: RefdsIconSymbol = .dollarsign
    
    var body: some View {
        IconSelection(icon: $icon, color: .accentColor)
    }
}

struct IconSelection_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectionView()
    }
}
